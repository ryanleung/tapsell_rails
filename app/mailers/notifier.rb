class Notifier < ActionMailer::Base
  default from: "team@tapsell.co"

  def send_welcome_email(user)
    @user = user
    mail(:to => @user.email,
    :bcc => "team@tapsell.co",
    :subject => "Welcome to Tapsell!")
  end

end