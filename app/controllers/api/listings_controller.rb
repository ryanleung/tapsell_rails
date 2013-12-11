class Api::ListingsController < Api::ApiController

	before_filter :build_listing, only: [:create]
	before_filter :create_listing, only: [:create]

	def index
		render json: {
			error: nil,
			data: @current_user.listings.map{ |l| l.api_hash }
		}
	end

	def create
		render status: 200, json: {
      error: nil,
      # TODO(ben): this needs :user_trusted and :rec_rereced.
      data: @listing.api_hash
    }
	end

	def build_listing
		@listing = Listing.new(
			seller_id: @current_user.id,
			address: Address.find(params[:address_id]),
			title: params[:title],
			category: params[:category],
			date: params[:date],
			info: params[:info],
			post_to_craigslist: params[:post_craig],
			post_to_fb_timeline: params[:post_facebook],
			post_to_free_for_sale: params[:post_fof],
			price: params[:price],
			status: params[:status]
			)
	end

	def create_listing
		 begin
      unless @listing.save
        render status: 422, json: {
          error: "Could not create listing"
        }
      end
    rescue ActiveRecord::ActiveRecordError
      render status: 422, json: {
        error: "Could not create listing"
      }
    end
	end
	
end 