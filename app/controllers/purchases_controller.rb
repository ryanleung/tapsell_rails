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
    @listing = Listing.find(params[:id])
    @user = current_user
    result = Braintree::Transaction.sale(
    :amount => @listing.price,
    :credit_card => {
      :number => params[:number],
      :cvv => params[:cvv],
      :expiration_month => params[:exp_month],
      :expiration_year => params[:exp_year]
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
    @credit_card = @user.credit_cards.build(credit_card_params)
    @credit_card.save

    first_four = params[:number].to_s[0..-13].to_i
    last_four = params[:number].to_s[12..17].to_i
    @credit_card.update_attribute(:starting_digits, first_four)
    @credit_card.update_attribute(:ending_digits, last_four)

    # Todo - Add method for setting braintree token

    redirect_to purchase_confirmation_path
  end

  def purchase_confirmation
    @listing = Listing.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def credit_card_params
      params.permit(:exp_month, :exp_year, :card_type)
    end

end
