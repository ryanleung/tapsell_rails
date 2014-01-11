class BankAccountsController < ApplicationController
  
  def create
    @user = current_user
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
        :street_address => "111 Main St",
        :locality => "Chicago",
        :region => "IL",
        :postal_code => "60622"
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

end
