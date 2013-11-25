class Api::ApiController < ApplicationController
	API_SESSION_TOKEN_HEADER = 'X-TapsellAPIToken'

	before_filter :maybe_login_current_user
	before_filter :require_current_user

	private

	def maybe_login_current_user
		token = request.headers[API_SESSION_TOKEN_HEADER]
		if token.present?
			@api_session = ApiSession.find_by_token(token)
			if @api_session
				@current_user = @api_session.user
			end
		end
	end

	def require_current_user
		unless @current_user
			render status: 401, json: {
				error: "User must be logged in for this action."
			}
		end
	end

	
end