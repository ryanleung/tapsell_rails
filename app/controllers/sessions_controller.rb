class SessionsController < ApplicationController

  def new
  	render 'new'
  end

  def create
  	user = User.authenticate(params[:session][:email].downcase, params[:session][:password])
  	if not user.nil?
      flash.delete(:notice)
      sign_in user
      redirect_back_or dashboard_path(current_user.id)
    elsif user.deactivated
      flash[:notice] = 'This email has been deactivated, please email team@tapsell.co to reactivate.'
      render 'new'
    else
      flash[:notice] = 'That email / password combination is invalid, please try again.'
      render 'new'
    end	
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end