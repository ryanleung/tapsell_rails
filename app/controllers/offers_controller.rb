class OffersController < ApplicationController

  def confirm_listings_page
    @listing = Listing.find(params[:id])
    @offer_price = params[:offer_price]
    if signed_in?
      create_new_offer
    else
      @user = User.new
      render '_sign_in_to_offer'
      store_location
    end
  end

  def create_new_offer
    @user = current_user
    # @credit_card = get_chosen_credit_card
    # if @credit_card.nil?
    #   @listing = Listing.find(params[:listing_id].to_i)
    #   @offer_price = params[:offer_price].to_f
    #   flash[:notice] = 'There was a problem creating the offer.  Please double-check your credit card information and try again.'
    #   render '_confirm_offer'
    #   return
    # end

    create_authorization
    @offer = Offer.create_offer!(current_user, Listing.find(@listing), @credit_card, params[:offer_price].to_f)
    buyer = @offer.buyer
    seller = @offer.seller
    Notifier.send_offer_received_email(seller, @offer).deliver
    Notifier.send_offer_confirmation_email(buyer, @offer).deliver
    redirect_to offer_confirmation_path({:offer_id => @offer.id, :message => params[:message]})
  end

  def offer_confirmation
    @offer = Offer.find(params[:offer_id])
    @listing = @offer.listing

    # If the offer created is successful, delete notice messages and initialize timer/send inquiry message.
    # Create offer message to seller, then add additional message.
    flash.delete(:notice)
    MessageChain.send_message(current_user.id, @listing.id, "#{current_user.first_name.titleize} #{current_user.last_name.titleize} offered #{ActionController::Base.helpers.number_to_currency(@offer.price)} for #{@listing.title}." , Message::TYPE_OFFER, nil, @offer)
    if params[:message].present?
      MessageChain.send_message(current_user.id, @listing.id, params[:message], Message::TYPE_DEFAULT, nil, nil)
    end

    @offer.initialize_accept_timer
  end

  def get_chosen_credit_card
    credit_card = nil
    # if there is a chosen card id, use that
    if params[:chosen_card_id].present?
      credit_card = CreditCard.find(params[:chosen_card_id].to_i)
    else
      # otherwise, verify form stuff and create card
      begin
        credit_card = CreditCard.create_cc(current_user, params[:number], params[:exp_month].to_i, params[:exp_year].to_i, params[:cvc])
      rescue
        return nil
      end
    end
    return credit_card
  end

  def create_authorization
    # Authorize credit cards here
  end
  
end