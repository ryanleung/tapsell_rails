class SessionsController < ApplicationController

  def new
  	render 'new'
  end

  def create
  	user = User.authenticate(params[:session][:email].downcase, params[:session][:password])
  	if not user.nil?
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end	
  end

  def destroy
  end

end