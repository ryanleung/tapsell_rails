class TutorialPagesController < ApplicationController

  def landing
    render :layout => false
  end

  def sign_up
    @user = User.new(user_params)
    if @user.save
      store_location
      create_remember_token
      sign_in @user
      flash[:success] = "Welcome to Tapsell!"
      redirect_to tutorial_step_one_path
      # Notifier.send_welcome_email(@user).deliver
    else
      render 'sign_up'
    end
  end

  def step_one
    render :layout => false
  end

  def step_two
    render :layout => false
  end

  def step_three
    render :layout => false
  end

  def step_four
    render :layout => false
  end

  def step_five
    render :layout => false
  end

  def step_six
    render :layout => false
  end

  def finish
    render :layout => false
  end

private

  def user_params
      params.permit(:user, :first_name, :last_name, :email, :password, :password_confirmation, :bio)
  end

end
