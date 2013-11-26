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

	def fetch_user
    # Note that #find_by_id will return nil when #find would raise an AR
    # exception (so we use the former here).
    if params[:user_id].blank?
      @user = nil
    elsif params[:user_id].to_i.to_s == params[:user_id].to_s
      @user = User.find_by_id(params[:user_id].to_i)
    end

    if @user.blank?
      render status: 404, json: {
        error: "user not found ('#{params[:user_id]}')"
      }
    end
  end

  def fetch_users
    if params[:user_id].blank?
      @users = nil
    else
      user_ids = params[:user_id].map(&:upcase)
      @users = User.where(
        "id IN (?) OR UPPER(username) IN (?)",
        user_ids.map{|u| u.to_i}, user_ids
      )
    end

    unless @users.present?
      render status: 404, json: {
        error: "user not found ('#{params[:user_ids]}')"
      }
    end
  end

	
end