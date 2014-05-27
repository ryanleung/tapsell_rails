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
    @current_user = current_user
    @listings = @current_user.listings_as_seller.order("created_at DESC")
    @greeting = Greeting.random_greeting
  end

  def new
    @user = current_user
    @listing = Listing.new
    4.times { @listing.images.build }
  end

  def create
    @user = current_user
    @listing = current_user.listings_as_seller.build(listing_params)
    @listing.status = Listing::STATUS_ACTIVE

    # TODO: another sad hack :-(. Images parsing
    images_hash = params["listing"]["images_attributes"]
    if images_hash.present?
      images_hash.values.each do |image|
        img = Image.new(image)
        @listing.images.push(img)
      end
    end
    if @listing.save
      flash[:success] = "Listing created!"
      redirect_to confirm_listing_path(@listing)
      Notifier.delay.send_item_posted_email(@user)
    else
      flash[:notice] = "Oops!  There was a problem creating the listing, please try again.  #{@listing.errors.full_messages.join(', ')}"
      redirect_to new_listing_path
    end
  end

  def show
    @user = current_user
    @listing = Listing.find(params[:id])
  end

  def edit
    @user = current_user
    @listing = Listing.find(params[:id])
  end

  def update
    @listing = Listing.find(params[:id])
    if @listing.update_attributes(listing_params)
      flash[:success] = "Listing update successful!"
      redirect_to @listing
    else
      flash[:notice] = "There was a problem updating your listing.  Please double-check and try again!"
      render 'edit'
    end
  end

  def confirm_listing
    @user = current_user
    @listing = Listing.find(params[:id])
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.remove

    redirect_to :action => :show_my_listings
  end

  def direct_message
    @msg_chain = MessageChain.send_message(current_user.id, params[:listing_id],
              params[:content], nil, nil, nil)
    redirect_to :action => :show
  end

private

  def order_listings(sort_detail)
    @listings = Listing.all.order(sort_detail).page(params[:page]).limit(28)
  end

  def order_by_category(name)
    @listings = Listing.where(category: name).order("created_at DESC").page(params[:page]).limit(28)
  end

  def listing_params
    params.require(:listing).permit(:title, :category, :info, :post_to_craigslist, :post_to_fb_timeline, :post_to_fb_timeline, :price)
  end

end
