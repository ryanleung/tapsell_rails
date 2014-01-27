class Notifier < ActionMailer::Base
  default from: "team@tapsell.co"

  def send_welcome_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Welcome to Tapsell!")
  end

  def send_password_reset_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Password reset instructions")
  end

  def send_item_posted_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Your listing was posted!")
  end

  def send_offer_confirmation_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Offer confirmation")
  end  

end