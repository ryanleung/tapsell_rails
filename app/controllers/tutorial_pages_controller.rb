class TutorialPagesController < ApplicationController
  layout "no_format_tutorial_pages", except: [:sign_up]

  def landing
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

private

  def user_params
      params.permit(:user, :first_name, :last_name, :email, :password, :password_confirmation, :bio)
  end

end
