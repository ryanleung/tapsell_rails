class CreditCardsController < ApplicationController

  def create_card
    @user = current_user
    if @user.credit_cards.nil?
      create_first_card
    else
      create_additional_card
    end
    redirect_to payment_settings_path
  end


  def create_first_card
    @user = current_user
    @credit_card = CreditCard.new

    result = Braintree::Customer.create(
    :id => @user.id
    :first_name => @user.first_name,
    :last_name => @user.last_name,
    :email => @user.email,
    :credit_card => {
      :token => @credit_card.id,
      :number => params[:number],
      :cvv => params[:cvv],
      :expiration_month => params[:exp_month],
      :expiration_year => params[:exp_year]
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
  end

  def create_additional_card
    @user = current_user
    @credit_card = CreditCard.new

    result = Braintree::CreditCard.create(
      :customer_id => @user.id,
      :token => @credit_card.id,
      :number => params[:number],
      :expiration_month => params[:exp_month],
      :expiration_year => params[:exp_year]
    )

    @credit_card = @user.credit_cards.build(credit_card_params)
    @credit_card.save

    first_four = params[:number].to_s[0..3].to_i
    last_four = params[:number].to_s[-4..-1].to_i

    @credit_card.update_attribute(:starting_digits, first_four)
    @credit_card.update_attribute(:ending_digits, last_four)

    @credit_card.update_attribute(:braintree_token, @credit_card.id)
  end

  private

  def credit_card_params
    params.permit(:exp_month, :exp_year, :card_type)
  end

end

