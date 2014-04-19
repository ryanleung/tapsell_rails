class CreditCardsController < ApplicationController
  def create_card
    #TODO: MOVE THIS!!!!!!!!
    Stripe.api_key = "sk_test_I44IlUxXmgOwyYPfcafWPKKg"
    cc = CreditCard.create_cc(current_user, params[:number], params[:exp_month], params[:exp_year], params[:cvv_number])
    if cc.present?
      redirect_to user_settings_path
    end
  end
end