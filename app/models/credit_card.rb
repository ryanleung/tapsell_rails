class CreditCard < ActiveRecord::Base

  # Relationships
  # -------------
  belongs_to :address #, :with_deleted => true
  belongs_to :user

  # has_many :offers

  # Validations
  # -----------


  validates_uniqueness_of :braintree_token,
                          :message => "Multiple credit cards cannot be linked to same Braintree Credit Card"

  validates_format_of :last_4,
                      :with => /\d{4}/,
                      :message => "must be 4 digits"
  validates_format_of :expiration_month,
                      :with => /\d{2}/,
                      :message => "must be 2 digits"
  validates_format_of :expiration_year,
                      :with => /\d{4}/,
                      :message => "must be 4 digits"

  # Class Methods
  # -------------


  def self.create_cc(user, enc_cc_number, enc_cc_month, enc_cc_year, enc_postal_code)
    begin
      braintree_customer_id = user.find_or_create_braintree_customer_id
      bt_result = Braintree::CreditCard.create(
        # We will implicitly create a new Braintree customer_id here if needed.
        customer_id: braintree_customer_id,
        number: enc_cc_number,
        expiration_month: enc_cc_month,
        expiration_year: enc_cc_year,
        billing_address: {
          postal_code: enc_postal_code
        }
      )
    rescue Braintree::ValidationsFailed => vf
      return render status: 500, json: {
        error: "Braintree Validation Error: #{vf}"
      }
    rescue Braintree::UnexpectedError => ue
      return render status: 500, json: {
        error: "Braintree UnexpectedError: #{ue}"
      }
    rescue Braintree::NotFoundError => nfe
      return render status: 500, json: {
        error: "Braintree NotFoundError: #{nfe}"
      }
    end
    unless bt_result.is_a?(Braintree::SuccessfulResult)
      return render status: 500, json: {
        error: "Braintree Error: #{bt_result.errors}"
      }
    end

    credit_card = CreditCard.find_or_create_from_braintree_credit_card(
      user, bt_result.credit_card)

    credit_card
  end

  # Looks for the most recently used preexisting CreditCard associated with the
  # given user / Braintree customer, or creates one if none could be found.
  #
  # user_id: the AR user_id associated with the CreditCard, or nil for the
  #   logged-out case (common in checkout).
  # bt_customer: a Braintree customer object. See the braintree ruby
  #   documentation for details. This code assumes that bt_customer.success? is
  #   true.
  # billing_address_id: the billing address to associate with a new credit
  #   card. For merely finding an existing credit card, it may be unspecified.
  def self.find_or_create_from_braintree_customer(user_id,
                                                  bt_customer,
                                                  billing_address_id)
    if (bt_customer.nil? ||
        bt_customer.credit_cards.nil?)
      raise "Braintree customer or credit_cards were nil: #{bt_customer}"
    end

    if bt_customer.credit_cards.empty?
      return nil
    end

    # Find the most-recently-updated credit card for this user.
    bt_credit_card = bt_customer.credit_cards.sort { |a, b|
      a.updated_at <=> b.updated_at
    }.last

    # Delegate.
    find_or_create_from_braintree_credit_card(
      user_id, bt_credit_card, billing_address_id: billing_address_id)
  end

  # Available options:
  #
  #   :billing_address_id => int
  #     iff present, require that a billing address be associated with any
  #     new CreditCard, and add the given address association to the created
  #     CreditCard.
  def self.find_or_create_from_braintree_credit_card(user_id,
                                                     bt_credit_card,
                                                     options={})
    # Look for an existing entry with this BT token.
    token = bt_credit_card.token
    c = CreditCard.find_by_braintree_token(token)
    unless c.nil?
      if user_id
        if user_id != c.user_id
          raise "Braintree CC token already associated with user: #{user_id}"
        end
      end
      return c
    end

    # Could not find an existing CreditCard record; create one.
    #
    # First, we determine the cardholder name.
    cardholder_name = bt_credit_card.cardholder_name

    # Verify the billing address before proceeding.
    if options[:billing_address_id].present?
      if bt_credit_card.billing_address.nil?
        raise "bt_credit_card has no billing_address: #{bt_credit_card}"
      end

      if !cardholder_name && bt_credit_card.billing_address
        bt_addr = bt_credit_card.billing_address
        cardholder_name = "#{bt_addr.first_name} #{bt_addr.last_name}"
      end
    end

    # Create the CreditCard record.
    CreditCard.create!(
      user_id: user_id,
      braintree_token: token,
      address_id: options[:billing_address_id],
      cardholder_name: cardholder_name,
      last_4: bt_credit_card.last_4,
      card_type: bt_credit_card.card_type,
      expiration_month: bt_credit_card.expiration_month,
      expiration_year: bt_credit_card.expiration_year
    )
  end
end