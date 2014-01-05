class PurchasesController < ApplicationController

  def new
    @listing = Listing.find(params[:id])
    if signed_in?
      render '_confirm_purchase'
      @user = @current_user
    else
      @user = User.new
      render '_sign_in_to_purchase'
    end
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      create_remember_token
      sign_in @user
      redirect_to new_purchase_path
    else
      render '_sign_in_to_purchase'
    end    
  end

  def create_transaction
    result = Braintree::Transaction.sale(
    :amount => "1000.00",
    :credit_card => {
      :number => params[:number],
      :cvv => params[:cvv],
      :expiration_month => params[:month],
      :expiration_year => params[:year]
    },
    :options => {
      :submit_for_settlement => false
    }
  )
    redirect_to purchase_confirmation_path
  end

  def purchase_confirmation
    @listing = Listing.find(params[:id])
  end

  private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end
