class Notifier < ActionMailer::Base
  default from: '"Tapsell" <team@tapsell.co>'

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

  def send_offer_confirmation_email(buyer, offer)
    @buyer = buyer
    @offer = offer
    mail(:to => @buyer.email,
    :bcc => "team@tapsell.co",
    :subject => "Confirmation of your offer")
  end

  def send_offer_accepted_email(buyer, offer)
    @buyer = buyer
    @offer = offer
    mail(:to => @buyer.email,
    :bcc => "team@tapsell.co",
    :subject => "Your offer was accepted!")
  end

  def send_offer_rejected_email(buyer, offer)
    @buyer = buyer
    @offer = offer
    mail(:to => @buyer.email,
    :bcc => "team@tapsell.co",
    :subject => "Your offer was declined")
  end

  # Transaction process emails (Seller)

  def send_offer_received_email(seller, offer)
    @seller = seller
    @offer = offer
    mail(:to => @seller.email,
    :bcc => "team@tapsell.co",
    :subject => "New offer for your listing!")
  end


  def send_offer_acceptance_confirmation_email(seller, offer)
    @seller = seller
    @offer = offer
    mail(:to => @seller.email,
    :bcc => "team@tapsell.co",
    :subject => "Confirming the offer you accepted")
  end

  # Launch emails (Phil's BBQ)

  def send_launch_email(user)
    @user = user
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Certificate Confirmation from Tapsell")
  end

  # Review emails

  def send_review_email(review)
    @review = review
    mail(:to => @review.reviewer.email,
      :bcc => "team@tapsell.co",
      :subject => "Please review #{@review.reviewer.full_name.titleize}")
  end
  
end