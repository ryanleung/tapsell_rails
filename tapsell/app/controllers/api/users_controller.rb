class Api::UsersController < Api::ApiController
	skip_before_filter :require_current_user, only: [:create]
	before_filter :create_user_from_params, only: [:create]

	def create
		authed_user =  User.authenticate(params[:email], params[:password])
		# Return an access token as a courtesy to save the client a round-trip to
    # authenticate.
    access_token = ApiSession.create(user: authed_user)
    render json: {
      error: nil,
      data: {
        user: @user,
        api_token: access_token.token
      }
    }
	end

	def create_user_from_params
		begin
			User.transaction do
				@user = User.new(
					first_name: params[:first_name],
					last_name: params[:last_name],
					email: params[:email],
					username: params[:username],
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