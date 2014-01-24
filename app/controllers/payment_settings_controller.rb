class PaymentSettingsController < ApplicationController

  def index
    @user = current_user
    @check = Check.new
    @bank_account = BankAccount.new
    @credit_cards = CreditCard.order("created_at desc")
  end

end
