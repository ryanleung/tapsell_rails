class PurchasesController < ApplicationController

  def new
    @listing = Listing.find(params[:id])
    if signed_in?
      @user = current_user
      render '_confirm_purchase'
    else
      @user = User.new
      render '_sign_in_to_purchase'
      store_location
    end
  end

  # Needs to be extended to deal with using existing cards
  # Lots of repetitive code needs to be generalized
  # Needs to be extended to work with offers instead of fixed prices
  # Needs to be extended to handle primary cards
  # Needs to be extended to handle selected payout methods

  # Testing purposes only
  def create_authorization
    @listing = Listing.find(params[:id])
    @user = current_user
    @seller = @listing.seller
    
    add_card_no_merch
  end

  # Working except for cc token
  def first_card_no_merch
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

    first_four = params[:number].to_s[0..3].to_i
    last_four = params[:number].to_s[-4..-1].to_i

    @credit_card.update_attribute(:starting_digits, first_four)
    @credit_card.update_attribute(:ending_digits, last_four)
    
    @credit_card.update_attribute(:braintree_token, @credit_card.id)
    @user.update_attribute(:braintree_id, @user.id)
    @user.update_attribute(:primary_card_id, @credit_card.id)
  
    # Need to extend this so it only redirects if the purchase is successful
    redirect_to purchase_confirmation_path
  end

  # Not working
  def add_card_no_merch
    @credit_card = CreditCard.new

    # Not sure if this needs to be split up into separate create and update actions
    #result = Braintree::Transaction.sale(
    #  :amount => @listing.price,
    #  :credit_card => {
    #    :token => @credit_card.id,
    #    :number => params[:number],
    #    :cvv => params[:cvv],
    #    :expiration_month => params[:exp_month],
    #    :expiration_year => params[:exp_year],
    #  },
    #  :customer => {
    #    :id => @user.id
    #  },
    #  :options => {
    #    :submit_for_settlement => false,
    #    :store_in_vault => true
    #  }
    #)

    # This keeps failing and I don't know why
    result = Braintree::CreditCard.create(
      :customer_id => @user.id,
      :number => params[:number],
      :expiration_month => params[:exp_year],
      :expiration_year => params[:exp_month]
    )

    transaction = result.success?

    # This succeeds
    result2 = Braintree::Transaction.sale(
      :amount => @listing.price,
      :credit_card => {
        :token => @credit_card.id,
        :number => params[:number],
        :cvv => params[:cvv],
        :expiration_month => params[:exp_month],
        :expiration_year => params[:exp_year],
        },
      :options => {
        :submit_for_settlement => false,
        :store_in_vault => true
      }
    )

    transaction2 = result2.success?


    #@credit_card = @user.credit_cards.build(credit_card_params)
    #@credit_card.save

    first_four = params[:number].to_s[0..3].to_i
    last_four = params[:number].to_s[-4..-1].to_i

    #@credit_card.update_attribute(:starting_digits, first_four)
    #@credit_card.update_attribute(:ending_digits, last_four)
    
    #@credit_card.update_attribute(:braintree_token, @credit_card.id)
  
    redirect_to purchase_confirmation_path
  end

  def existing_card_no_merch
  end

  def first_card_with_merch
    @credit_card = CreditCard.new
    
    result = Braintree::Transaction.create(
    :amount => @listing.price,
    :merchant_account_id => @seller.bank_account.id,
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

    first_four = params[:number].to_s[0..3].to_i
    last_four = params[:number].to_s[-4..-1].to_i

    @credit_card.update_attribute(:starting_digits, first_four)
    @credit_card.update_attribute(:ending_digits, last_four)
    
    @credit_card.update_attribute(:braintree_token, @credit_card.id)
    @user.update_attribute(:braintree_id, @user.id)
    @user.update_attribute(:primary_card_id, @credit_card.id)
  
    redirect_to purchase_confirmation_path
  end

  def add_card_with_merch
    @credit_card = CreditCard.new

    result = Braintree::Transaction.sale(
      :amount => @listing.price,
      :merchant_account_id => @seller.id,
      :credit_card => {
        :token => @credit_card.id,
        :number => params[:number],
        :cvv => params[:cvv],
        :expiration_month => params[:exp_month],
        :expiration_year => params[:exp_year],
      },
      :customer => {
        :id => @user.id
      },
      :options => {
        :submit_for_settlement => false,
        :store_in_vault => true
      }
    )
    
    @credit_card = @user.credit_cards.build(credit_card_params)
    @credit_card.save

    first_four = params[:number].to_s[0..3].to_i
    last_four = params[:number].to_s[-4..-1].to_i

    @credit_card.update_attribute(:starting_digits, first_four)
    @credit_card.update_attribute(:ending_digits, last_four)
    
    @credit_card.update_attribute(:braintree_token, @credit_card.id)
  end

  def existing_card_with_merch
  end

  def purchase_confirmation
    @user = current_user
    @listing = Listing.find(params[:id])
  end

  private

    def credit_card_params
      params.permit(:exp_month, :exp_year, :card_type)
    end

end
