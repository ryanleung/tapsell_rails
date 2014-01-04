class PurchasesController < ApplicationController

  def new
    @listing = Listing.find(params[:id])
    if signed_in?
      @user = current_user
    else
      @user = User.new
    end
  end

  def create
  end

end
