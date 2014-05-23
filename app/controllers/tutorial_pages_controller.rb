class TutorialPagesController < ApplicationController
  layout "no_format_tutorial_pages", except: [:sign_up]

  def landing
  end

  def sign_up
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      store_location
      @user.remember_token = User.encrypt(User.new_remember_token)
      sign_in @user
      flash[:success] = "Welcome to Tapsell!"
      redirect_to tutorial_step_one_path
      # Notifier.send_welcome_email(@user).deliver
    else
      flash[:notice] = 'That email / password combination is invalid, please try again.'
      redirect_to tutorial_sign_up_path
    end
  end

  def step_one
    flash.delete(:notice)
  end

  def step_two
  end

  def step_three
  end

  def step_four
  end

  def step_five
  end

  def step_six
  end

  def finish
  end

  def get_certificate
    Notifier.send_launch_email(current_user).deliver
    flash[:success] = 'Congratulations! The certificate was sent to your email!'
    redirect_to tutorial_finish_path
  end

private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :bio)
  end

end
