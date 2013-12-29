class Api::UsersController < Api::ApiController
	skip_before_filter :require_current_user, only: [:create, :show]
	before_filter :create_user_from_params, only: [:create]
	before_filter :fetch_user, only: [:show]

	def show
		render json: {
			error: nil,
			data: @user.api_hash
		}
	end

	def create
		authed_user =  User.authenticate(params[:email], params[:password])
		# Return an access token as a courtesy to save the client a round-trip to
    # authenticate.
    access_token = ApiSession.create(user: authed_user)
    render json: {
      error: nil,
      data: {
        user: @user.api_hash,
        api_token: access_token.token
      }
    }
	end

	def update
		if params[:first_name].present?
      @current_user.first_name = params[:first_name]
    end
    if params[:last_name].present?
      @current_user.last_name = params[:last_name]
    end
    if params[:bio].present?
      @current_user.bio = params[:bio]
    end
    if params[:email].present?
      @current_user.email = params[:email]
    end
    if params[:city].present?
    	@current_user.city = params[:city]
    end
    if params[:state].present?
    	@current_user.state = params[:state]
    end
    if @current_user.save
      render json: {
        error: nil,
        data: {}
      }
    else
      render status: 500, json: {
        error: "Could not save edit: #{e.message}"
      }
    end
	end

	def create_user_from_params
		begin
			User.transaction do
				@user = User.new(
					first_name: params[:first_name],
					last_name: params[:last_name],
					email: params[:email],
					password: params[:password]
					)
				@user.save!
			end
		rescue => e
			render status: 422, json: {
				error: "Could not create user: #{e.message}"
			}
		end
	end

end