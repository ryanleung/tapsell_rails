class DashboardController < ApplicationController
  def show
    sorted_msg_chains = current_user.message_chains.try(:last, 5).sort_by &:created_at
    @recent_msg_chains = sorted_msg_chains.reverse
    @active_listings = current_user.listings_as_seller.order("created_at DESC").try(:last, 5)
  end
end
