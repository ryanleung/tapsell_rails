class MarketingEmailsController < ApplicationController
  def create
  end

  private

  def marketing_email_params
      params.require(:email)
  end

end
