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
    redirect_to offer_confirmation_path
  end

  def offer_confirmation
    @listing = Listing.last
    @listing.title = "hello"
  end
  
end