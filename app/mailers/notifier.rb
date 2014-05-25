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

  def send_message_notification_email(receiver, sender, listing, message_body)
    @receiver = receiver
    @sender = sender
    @listing = listing
    @message_body = message_body
    mail(:to => @receiver.email,
    :bcc => "team@tapsell.co",
    :subject => "You have a new message!")
  end

  # Transaction process emails (Buyer)

  def send_offer_confirmation_email(buyer)
    @buyer = buyer
    mail(:to => @buyer.email,
    :bcc => "team@tapsell.co",
    :subject => "Confirmation of your offer")
  end

  def send_offer_accepted_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Your offer was accepted!")
  end

  # Transaction process emails (Seller)

  def send_offer_received_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Offer confirmation")
  end


  def send_offer_acceptance_confirmation_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Confirmation of offer acceptance")
  end

  # Launch emails (Phil's BBQ)

  def send_launch_email(user)
    @user = user
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Certificate Confirmation from Tapsell")
  end

end