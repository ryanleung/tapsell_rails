class MarketingEmailsController < ApplicationController
  
  def launch
  end

  def create
    @marketing_email = MarketingEmail.new(marketing_email_params)
    if @marketing_email.save
      redirect_to root_path
      flash[:notice] = "RSVP successful!  You'll receive an email confirmation with further instructions this week."
    else
      redirect_to root_path
      flash[:notice] = "Oops!  There was a problem with the email you submitted.  Please double-check and try again."
    end
  end

  private

  def marketing_email_params
    params.permit(:email)
  end

end
