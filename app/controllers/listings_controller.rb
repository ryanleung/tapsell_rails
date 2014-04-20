class ListingsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]

  def index
    @user = current_user

    # TODO: HACK, can't figure out how to redirect,
    # look at search_listings
    if session[:is_search].present?
      @listings = session[:search_listing_ids].empty? ? Listing.none : Listing.where(id: session[:search_listing_ids]).order("created_at DESC")
    else
      order_listings("created_at DESC")
    end

    # clear session
    session.delete(:is_search)
    session.delete(:search_listing_ids)
  end

  def search_listings
    session[:is_search] = true
    session[:search_listing_ids] = Listing.search(params[:search]).collect(&:id)
    redirect_to :action => :index
  end

  def all_listings
    order_listings("created_at DESC")
  end

  def book_listings
    order_by_category("Books")
  end

  def apparel_listings
    order_by_category("Apparel")
  end

  def electronic_listings
    order_by_category("Electronics")
  end

  def home_listings
    order_by_category("Home")
  end

  def ticket_listings
    order_by_category("Tickets")
  end

  def other_listings
    order_by_category("Other")
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
    4.times { @listing.images.build }
  end

  def create
    @listing = current_user.listings_as_seller.build(listing_params)
    if @listing.save
      flash[:success] = "Listing created!"
      redirect_to confirm_listing_path(@listing)
    else
      flash[:notice] = "There was a problem creating the listing, try again."
      redirect_to new_listing_path
    end
  end

  def show
    @user = current_user
    @listing = Listing.find(params[:id])
  end

  def confirm_listing
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
