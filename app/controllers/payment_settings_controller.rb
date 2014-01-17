class PaymentSettingsController < ApplicationController

  def index
    @user = current_user
    @check = Check.new
    @bank_account = BankAccount.new
    @address = Address.new
  end

end
