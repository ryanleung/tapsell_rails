class Api::ListingsController < Api::ApiController

	before_filter :build_listing, only: [:create]
	before_filter :create_listing, only: [:create]

	def index
		render json: {
			error: nil,
			data: @current_user.selling_listings.map{ |l| l.api_hash }
		}
	end

	def create
		render status: 200, json: {
      error: nil,
      data: @listing.api_hash
    }
	end

	private

	def build_listing
		pic_data = []
		if !params[:pic_data_1].blank?
			pic_data.push(params[:pic_data_1])
		end
		if !params[:pic_data_2].blank?
			pic_data.push(params[:pic_data_2])
		end
		if !params[:pic_data_3].blank?
			pic_data.push(params[:pic_data_3])
		end
		if !params[:pic_data_4].blank?
			pic_data.push(params[:pic_data_4])
		end
		images = []
		pic_data.each do |p|
			temp_file = Tempfile.new('tempfile')
			begin
				temp_file.binmode
				temp_file.write(Base64.decode64(p))
				img = Image.new()
				img.image = temp_file
				images.push(img)
			ensure
				temp_file.close
				temp_file.unlink
			end
		end

		@listing = Listing.new(
			seller_id: @current_user.id,
			title: params[:title],
			category: params[:category],
			info: params[:info],
			post_to_craigslist: params[:post_craigslist],
			post_to_fb_timeline: params[:post_facebook],
			post_to_free_for_sale: params[:post_ffs],
			price: params[:price],
			status: params[:status],
			images: images
			)
		if params[:address_id].blank?
			build_and_create_address
			@listing.address = @address
		else
			@listing.address = Address.find(params[:address_id])
		end
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

	# TODO(ryan): move this into model?
	def build_and_create_address
		begin
			@address = Address.new(
				street_address: params[:address][:street_address],
				extended_address: params[:address][:extended_address],
				locality: params[:address][:locality],
				region: params[:address][:region],
				postal_code: params[:address][:postal_code],
				phone: params[:address][:phone],
				email: params[:address][:email]
				)

			unless @address.save
				render status: 422, json: {
          error: "Could not create address"
        }
      end
    rescue ActiveRecord::ActiveRecordError
      render status: 422, json: {
        error: "Could not create address"
      }
    end
  end
end 