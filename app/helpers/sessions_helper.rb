module SessionsHelper

  def sign_in(user)
  	remember_token = User.new_remember_token
  	cookies.permanent[:remember_token] = remember_token
  	user.update_attribute(:remember_token, User.encrypt(remember_token))
  	self.current_user = user
  end

  def current_user=(user)
      @current_user = user
  end

  def current_user
      remember_token = User.encrypt(cookies[:remember_token])
      @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def signed_in?
  	!current_user.nil?
  end

  def deactivated?
    if current_user.present?
      return current_user.deactivated
    end
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to sign_in_path, notice: "Please sign in."
    end

    if deactivated?
      store_location
      redirect_to sign_in_path, notice: "This account has been deactivated, please contact team@tapsell.co to reactivate."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

end
