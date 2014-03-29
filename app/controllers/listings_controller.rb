class ListingsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]

  def index
    @user = current_user
    @listings = Listing.all
  end

  def new
    @user = current_user
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings_as_seller.build(listing_params)
    if @listing.save
      flash[:success] = "Listing created!"
      redirect_to root_url
    else
      flash[:notice] = "There was a problem creating the listing, try again."
      redirect_to new_listing_path
    end
  end

  def show
    @user = current_user
    @listing = Listing.find(params[:id])
  end

  def destroy
  end

private

  def listing_params
    params.require(:listing).permit(:title, :category, :info, :post_to_craigslist, :post_to_fb_timeline, :post_to_fb_timeline, :price)
  end

end
