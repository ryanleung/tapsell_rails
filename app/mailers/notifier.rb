class Notifier < ActionMailer::Base
  default from: "team@tapsell.co"

# General-purpose emails

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

  # Transaction process emails (Buyer)

  def send_offer_confirmation_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Offer confirmation")
  end  

  # Transaction process emails (Seller)

  def send_offer_received_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Offer confirmation")
  end

  # Launch

  def send_launch_email(user)
    @user = user
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Certificate Confirmation from Tapsell")
  end

end