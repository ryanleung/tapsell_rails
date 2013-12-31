class ListingsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.selling_listings.build(listing_params)
    if @listing.save
      flash[:success] = "Listing created!"
      redirect_to root_url
    else
      flash[:notice] = "There was a problem creating the listing, try again."
      redirect_to new_listing_path
    end
  end

  def show
    @listing = Listing.find(params[:id])
  end

  def destroy
  end

private
  
  def listing_params
    params.require(:listing).permit(:title, :category, :info, :post_to_craigslist, :post_to_fb_timeline, :post_to_fb_timeline, :price)
  end

end