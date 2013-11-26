class Api::SessionsController < Api::ApiController
	before_filter :authenticate, only: [:create]
	skip_before_filter :require_current_user, only [:create]

	def create
		access_token = ApiSession.create(user: @user)
		render json: {
			error: nil,
			data: {
				api_token: access_token.token,
				user: @user.api_hash
			}
		}
	end

	def destroy
		if @api_session.nil?
			render status: 401, json: {
				error: 'cannot destroy a non-authenticated session'
			}
		else
			@api_session.destroy
			render json: {
				error: nil,
				data: nil
			}
		end
	end

	def authenticate
		if params[:email].blank?
			render status: 400, json: {
				error: 'no email specified'
			}
		elsif params[:password].blank?
			render status: 401, json: {
				error: 'no password specified'
			}
		else
			@user = User.authenticate(params[:email], params[:password])
			if @user.blank?
				render status: 401, json: {
					error: 'incorrect password'
				}
			end
		end
	end

end