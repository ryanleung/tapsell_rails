class UserSettingsController < ApplicationController
  def index
    @user = current_user
  end

  def create_credit_card(cc_fields={})

  end
end