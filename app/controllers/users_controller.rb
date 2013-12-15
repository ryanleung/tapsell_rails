class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
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

end
