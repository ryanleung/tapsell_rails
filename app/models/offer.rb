class Offer < ActiveRecord::Base

  STATUS_WAITING_FOR_SELLER_RESPONSE = "waiting for seller response"
  STATUS_DENIED = "denied"
  STATUS_ACCEPTED = "accepted"
  STATUS_TRANSACTION_SUCCESSFUL = "transaction successful"
  STATUS_TRANSACTION_FAILED = "transaction failed"

  belongs_to :listing
  belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
  belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"

  def self.create_offer(buyer, listing)
  end

  def hold_in_escrow
  end

  def cancel
  end

end