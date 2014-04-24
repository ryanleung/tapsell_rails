class DashboardController < ApplicationController
  def show
    @recent_msg_chains = current_user.message_chains
    @active_listings = current_user.listings_as_seller.order("created_at DESC")
  end
end
