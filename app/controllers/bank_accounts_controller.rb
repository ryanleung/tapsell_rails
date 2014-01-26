class BankAccountsController < ApplicationController
  
  # Build and new might be redundant, test later with removing one or the other
  def create
    @user = current_user
    @address = Address.new
    @address = @user.addresses.build(address_params)
    @address.save
    @bank_account = BankAccount.new
    @bank_account = @user.bank_accounts.build(bank_account_params)
    @bank_account.save

    result = Braintree::MerchantAccount.create(
    :individual => {
      :first_name => params[:legal_first_name],
      :last_name => params[:legal_last_name],
      :email => @user.email,
      :date_of_birth => "1981-11-19",
      :address => {
        :street_address => params[:street_address],
        :locality => params[:locality],
        :region => params[:region],
        :postal_code => params[:postal_code]
      }
    },
    :funding => {
      :destination => Braintree::MerchantAccount::FundingDestination::Bank,
      :account_number => params[:account_number],
      :routing_number => params[:routing_number]
    },
    :tos_accepted => true,
    :master_merchant_account_id => "yhr253ts3gfd88kh",
    :id => @user.id
  )

    last_four = params[:account_number].to_s[-4..-1].to_i
    @bank_account.update_attribute(:ending_digits, last_four)
    @bank_account.update_attribute(:braintree_id, @user.id)
  end

  private

    def bank_account_params
      params.permit(:legal_first_name, :legal_last_name, :birth_day, :birth_month, :birth_year)
    end

    def address_params
      params.permit(:street_address, :extended_address, :locality, :region, :postal_code)
    end

end
