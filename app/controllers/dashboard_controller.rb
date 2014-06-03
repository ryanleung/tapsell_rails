class DashboardController < ApplicationController
  before_action :signed_in_user

  def show
    sorted_msg_chains = current_user.message_chains.try(:last, 3).sort_by &:updated_at
    @recent_msg_chains = sorted_msg_chains.reverse
    @active_listings = current_user.active_listings_as_seller.try(:last, 3)
    @greeting = Greeting.random_greeting
  end
end
