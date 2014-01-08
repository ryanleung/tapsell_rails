class PaymentSettingsController < ApplicationController

def index
  @user = current_user
  @check = Check.new
  @bank_account = BankAccount.new
end

end
