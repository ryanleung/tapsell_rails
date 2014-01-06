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
  
  # Create customer and transaction, save in Vault, return customer and card ID, and save to database
  def create_transaction
    @listing = Listing.find(params[:id])
    @user = current_user
    result = Braintree::Transaction.sale(
    :amount => @listing.price,
    :credit_card => {
      :number => params[:number],
      :cvv => params[:cvv],
      :expiration_month => params[:month],
      :expiration_year => params[:year]
    },
    :customer => {
      :email => @user.email.to_sym,
      :first_name => @user.first_name.to_sym,
      :last_name => @user.last_name.to_sym,
      :id => @user.id
    },
    :options => {
      :submit_for_settlement => false,
      :store_in_vault => true
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
