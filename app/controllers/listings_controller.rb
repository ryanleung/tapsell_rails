class ListingsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]

  def index
    @user = current_user
    order_listings("created_at DESC")
  end

  def all_listings
    order_listings("created_at DESC")
  end

  def book_listings
    order_by_category("book")
  end

  def apparel_listings
    order_by_category("apparel")
  end

  def electronic_listings
    order_by_category("electronic")
  end

  def home_listings
    order_by_category("home")
  end

  def ticket_listings
    order_by_category("ticket")
  end

  def other_listings
    order_by_category("other")
  end

  def newest_listings
    order_listings("created_at DESC")
  end

  def oldest_listings
    order_listings("created_at ASC")
  end

  def low_price_listings
    order_listings("price ASC")
  end

  def high_price_listings
    order_listings("price DESC")
  end

  def show_my_listings
    @user = current_user
  end

  def new
    @user = current_user
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
    @user = current_user
    @listing = Listing.find(params[:id])
  end

  def destroy
  end

private

  def order_listings(sort_detail)
    @listings = Listing.order(sort_detail).page(params[:page])
  end

  def order_by_category(name)
    @listings = Listing.where(category: name).order("created_at DESC").page(params[:page])
  end

  def listing_params
    params.require(:listing).permit(:title, :category, :info, :post_to_craigslist, :post_to_fb_timeline, :post_to_fb_timeline, :price)
  end

end
