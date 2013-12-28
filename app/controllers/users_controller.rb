class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show, :update]  
  before_action :correct_user, only: [:show, :update]

  def new
  	@user = User.new
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_remember_token
      sign_in @user
      flash[:success] = "Welcome to Tapsell!"
      redirect_to @user
      Notifier.send_welcome_email(@user).deliver
    else
      render 'new'
  	end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'show'
    end
  end

# Authorization methods for before filters
# Remove hard-coded path later

def signed_in_user
  redirect_to '/sign-in', notice: "Please sign in." unless signed_in?
end

def correct_user
  @user = User.find(params[:id])
  redirect_to(root_url) unless current_user?(@user)
end
  
private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :bio)
  end

  def create_remember_token
    @user.remember_token = User.encrypt(User.new_remember_token)
  end

end
