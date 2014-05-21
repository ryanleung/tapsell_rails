class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show, :update]  
  before_action :correct_user, only: [:show, :update]

  def new
  	@user = User.new
  end

  def show
    @greeting = Greeting.random_greeting
  end

  def show_public
    @user = current_user
    @seller = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      store_location
      create_remember_token
      sign_in @user
      flash[:success] = "Welcome to Tapsell!"
      redirect_to tutorial_step_one_path
      # Notifier.send_welcome_email(@user).deliver
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

  def new_photo
    img = Image.new(:image => params[:image])
    current_user.image = img
    if current_user.save
      redirect_to current_user
    else
      redirect_to current_user
    end
  end

private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :bio)
  end

  def create_remember_token
    @user.remember_token = User.encrypt(User.new_remember_token)
  end

end
