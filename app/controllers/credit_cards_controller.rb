class CreditCardsController < ApplicationController
  def create_card
    cc = CreditCard.create_cc(current_user, params[:number], params[:exp_month], params[:exp_year], params[:cvv_number])
    if cc.present?
      redirect_to user_settings_path
    end
  end

  def destroy
    begin
      CreditCard.delete_cc(CreditCard.find(params[:id]))
    rescue
      flash[:notice] = "Error: Credit card could not be deleted."
      redirect_to user_settings_path
      return
    end

    flash[:success] = "Credit card successfully deleted"
    redirect_to user_settings_path
  end
end