class MerchantAccount < ActiveRecord::Base
  # Relationships
  # -------------
  belongs_to :address #, :with_deleted => true
  belongs_to :user

  # has_many :offers

  # Validations
  # -----------


  validates_uniqueness_of :braintree_token,
                          :message => "Multiple merchant accounts cannot be linked to same Braintree Merchant Account"

  validates_format_of :last_4,
                      :with => /\d{4}/,
                      :message => "must be 4 digits"

  # Class Methods
  # -------------
  # If one does not exist already, create and save a braintree merchant id
  # for this customer via a server-to-server Braintree API call. Return
  # the found or created braintree id, which is a string.
  def self.create_merchant_account(user, accnt_number, routing_number, date_of_birth, address)
    user.date_of_birth = date_of_birth
    begin
      bt_result = Braintree::MerchantAccount.create(
        individual: {
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          phone: user.phone_number,
          date_of_birth: user.date_of_birth,
          address: {
            street_address: address.street_address,
            locality: address.locality,
            region: address.region,
            postal_code: address.postal_code,
          }
        },
        funding: {
          destination: Braintree::MerchantAccount::FundingDestination::Bank,
          account_number: accnt_number,
          routing_number: routing_number,
        },
        tos_accepted: true,
        master_merchant_account_id: "yhr253ts3gfd88kh",
      )
    rescue
      raise "Braintree Error: #{bt_result.errors}"
    end
    unless bt_result.is_a?(Braintree::SuccessfulResult) || !bt_result.success?
      raise "Braintree Error: #{bt_result.errors}"
    end

    last_4 = accnt_number.last(4)
    merchant_account = MerchantAccount.find_or_create_from_braintree_merchaccnt(
      user.id, address.id, bt_result.merchant_account, last_4)

    merchant_account
  end

  def self.find_or_create_from_braintree_merchaccnt(user_id, address_id, bt_merchant_account, last_4)
    token = bt_merchant_account.id
    ma = MerchantAccount.find_by_braintree_token(token)
    unless ma.nil?
      if user_id
        if user_id != ma.user_id
          raise "Braintree CC token already associated with user: #{user_id}"
        end
      end
      return ma
    end

    # If we couldn't find a merchant account, create one.
    MerchantAccount.create!(
      user_id: user_id,
      braintree_token: token,
      address_id: address_id,
      last_4: last_4,
    )
  end

end