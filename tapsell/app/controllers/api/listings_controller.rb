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

	end

	def build_listing
		# @listing = Listing.new(
		# 	seller_id: @current_user.id,
		# 	address: 
		# 	)
	end

	def create_listing
	end
	
end 