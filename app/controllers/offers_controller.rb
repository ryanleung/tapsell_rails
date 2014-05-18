class OffersController < ApplicationController

  def new
    @listing = Listing.find(params[:id])
    @offer_price = params[:offer_price]
    if signed_in?
      render '_confirm_offer'
    else
      @user = User.new
      render '_sign_in_to_offer'
      store_location
    end
  end

  def create_authorization
    @user = current_user
    credit_card = nil
    # if there is a chosen card id, use that
    if params[:chosen_card_id].present?
      credit_card = CreditCard.find(params[:chosen_card_id].to_i)
    else
      # otherwise, verify form stuff and create card
      begin
        credit_card = CreditCard.create_cc(current_user, params[:number], params[:exp_month].to_i, params[:exp_year].to_i, params[:cvc])
      rescue
        # TODO:HACK, find better way to reset
        @listing = Listing.find(params[:listing_id].to_i)
        @offer_price = params[:offer_price].to_f
        flash[:notice] = 'There was a problem creating the offer.  Please double-check your credit card information and try again.'
        render '_confirm_offer'
        return
      end
    end
    begin
      @offer = Offer.create_offer!(current_user, Listing.find(params[:listing_id].to_i), credit_card, params[:offer_price].to_f)
    rescue
      # TODO:HACK, find better way to reset
      @listing = Listing.find(params[:listing_id].to_i)
      @offer_price = params[:offer_price].to_f
      flash[:notice] = 'There was a problem creating the offer.  Please double-check your credit card information and try again.'
      render '_confirm_offer'
    end
    flash.delete(:notice)
    redirect_to offer_confirmation_path({:offer_id => @offer.id, :message => params[:message]})
    # Notifier.send_offer_received_email(@user).deliver
    Notifier.send_offer_confirmation_email(@user).deliver
  end

  def offer_confirmation
    @offer = Offer.find(params[:offer_id])
    @listing = @offer.listing

    # create offer message to seller, then add additional message
    MessageChain.send_message(current_user.id, @listing.id, "#{current_user.first_name} has offered #{ActionController::Base.helpers.number_to_currency(@offer.price)} for your listing, #{@listing.title}" , Message::TYPE_OFFER, nil, @offer)
    if params[:message].present?
      MessageChain.send_message(current_user.id, @listing.id, params[:message], Message::TYPE_DEFAULT, nil, nil)
    end
  end
  
end