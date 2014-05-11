class PasswordResetsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user == nil
      flash[:notice] = "The email you entered doesn't exist.  Please double-check and try again."
      redirect_to new_password_reset_path
    else
      user.initiate_password_reset if user
      redirect_to root_url, :notice => "We sent you an email with password reset instructions.  Check your inbox!"
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user].permit(:password, :password_confirmation))
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end

end
