class DashboardController < ApplicationController
  def show
    @recent_msg_chains = current_user.message_chains.try(:last, 5)
    @active_listings = current_user.listings_as_seller.order("created_at DESC").try(:last, 5)
  end
end
