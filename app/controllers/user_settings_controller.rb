class UserSettingsController < ApplicationController
  def index
    @user = current_user
    @greeting = Greeting.random_greeting
  end

  def create_credit_card(cc_fields={})

  end
end