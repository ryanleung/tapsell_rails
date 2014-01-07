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
    @credit_card = CreditCard.new
    
    result = Braintree::Transaction.sale(
    :amount => @listing.price,
    :credit_card => {
      :token => @credit_card.id,
      :number => params[:number],
      :cvv => params[:cvv],
      :expiration_month => params[:exp_month],
      :expiration_year => params[:exp_year]
    },
    :customer => {
      :email => @user.email,
      :first_name => @user.first_name,
      :last_name => @user.last_name,
      :id => @user.id
    },
    :options => {
      :submit_for_settlement => false,
      :store_in_vault => true
    }
  )
    @credit_card = @user.credit_cards.build(credit_card_params)
    @credit_card.save

    if params[:card_type] == "American Express"
      first_four = params[:number].to_s[0..-12].to_i
      last_four = params[:number].to_s.reverse[0..-12].reverse.to_i
    else
      first_four = params[:number].to_s[0..-13].to_i
      last_four = params[:number].to_s.reverse[0..-13].reverse.to_i
    end

    @credit_card.update_attribute(:starting_digits, first_four)
    @credit_card.update_attribute(:ending_digits, last_four)
    @credit_card.update_attribute(:braintree_token, @credit_card.id)
    @user.update_attribute(:braintree_id, @user.id)
    
    # Need to extend this later so it only redirects if the purchase is successful
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
