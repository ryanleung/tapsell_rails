class Recipient < ActiveRecord::Base
  # Relationships
  # -------------
  belongs_to :address #, :with_deleted => true
  belongs_to :user

  # has_many :offers

  # Validations
  # -----------


  validates_uniqueness_of :stripe_id,
                          :message => "Multiple merchant accounts cannot be linked to same Braintree Merchant Account"

  validates_format_of :last_4,
                      :with => /\d{4}/,
                      :message => "must be 4 digits"

  # Class Methods
  # -------------
  # If one does not exist already, create and save a stripe recipient id
  # for this customer via a server-to-server Stripe API call. Return
  # the found or created stripe id, which is a string.
  # Both accnt_number and routing_number are strings.
  def self.create_recipient(user, accnt_number, routing_number)
    begin
      st_result = Stripe::Recipient.create(
        name: "#{user.first_name} #{user.last_name}",
        type: "individual",
        bank_account: {
          country: "US",
          routing_number: routing_number,
          account_number: accnt_number,
        }
      )
    rescue => e
      raise "Stripe Recipient Create Error: #{e.message}"
    end

    recipient = Recipient.find_or_create_from_stripe_recipient(
      user.id, st_result)

    recipient
  end

  def self.find_or_create_from_stripe_recipient(user_id, st_recipient)
    stripe_id = st_recipient.id
    recipient = Recipient.find_by_stripe_id(stripe_id)
    unless recipient.nil?
      if user_id
        if user_id != recipient.user_id
          raise "Stripe recipient id already associated with user: #{user_id}"
        end
      end
      return recipient
    end

    # If we couldn't find a recipient, create one.
    Recipient.create!(
      user_id: user_id,
      stripe_id: stripe_id,
      last_4: st_recipient.active_account.last4,
    )
  end

end