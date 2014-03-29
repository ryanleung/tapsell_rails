class CreditCard < ActiveRecord::Base

  # Relationships
  # -------------
  belongs_to :address #, :with_deleted => true
  belongs_to :user

  # has_many :offers

  # Validations
  # -----------


  validates_uniqueness_of :stripe_id,
                          :message => "Multiple credit cards cannot be linked to same Stripe Credit Card"

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

  # enc_cc_number => string
  # enc_cc_month, enc_cc_year => integer
  def self.create_cc(user, enc_cc_number, enc_cc_month, enc_cc_year, cvc)
    begin
      stripe_customer_id = user.find_or_create_stripe_customer_id
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      st_result = customer.cards.create(
        card: {
          number: enc_cc_number,
          exp_month: enc_cc_month,
          exp_year: enc_cc_year,
          cvc: cvc,
          name: "#{user.first_name} #{user.last_name}",
        }
      )
    rescue => e
      raise "Stripe create cc error: #{e.message}"
    end

    credit_card = CreditCard.find_or_create_from_stripe_credit_card(
      user.id, st_result)

    credit_card
  end

  # Available options:
  #
  #   :billing_address_id => int
  #     iff present, require that a billing address be associated with any
  #     new CreditCard, and add the given address association to the created
  #     CreditCard.
  def self.find_or_create_from_stripe_credit_card(user_id,
                                                 st_credit_card,
                                                 options={})
    # Look for an existing entry with this BT token.
    stripe_id = st_credit_card.id
    c = CreditCard.find_by_stripe_id(stripe_id)
    unless c.nil?
      if user_id
        if user_id != c.user_id
          raise "Stripe CC token already associated with user: #{user_id}"
        end
      end
      return c
    end

    # Could not find an existing CreditCard record; create one.
    CreditCard.create!(
      user_id: user_id,
      stripe_id: stripe_id,
      address_id: options[:billing_address_id],
      last_4: st_credit_card.last4,
      card_type: st_credit_card.type,
      expiration_month: st_credit_card.exp_month,
      expiration_year: st_credit_card.exp_year
    )
  end
end