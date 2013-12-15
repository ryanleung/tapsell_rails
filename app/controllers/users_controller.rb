class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_remember_token
      flash[:success] = "Welcome to Tapsell!"
      redirect_to @user
    else
      render 'new'
  	end
  end

  def update
  end


private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def create_remember_token
    @user.remember_token = User.encrypt(User.new_remember_token)
  end

end
