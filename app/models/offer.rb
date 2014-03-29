class Offer < ActiveRecord::Base

  STATUS_WAITING_FOR_SELLER_RESPONSE = "waiting for seller response"
  STATUS_DENIED = "denied"
  STATUS_ACCEPTED = "accepted"
  STATUS_TRANSACTION_SUCCESSFUL = "transaction successful"
  STATUS_TRANSACTION_FAILED = "transaction failed"

  belongs_to :listing
  belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
  belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"

  def self.create_offer!(buyer, listing)
    offer = Offer.create!(
      seller: listing.seller,
      listing: listing,
      buyer: buyer,
      status: STATUS_WAITING_FOR_SELLER_RESPONSE,
    )

    offer
  end

  def self.accept_offer!(seller, offer)
    raise "Seller does not own offer" if offer not in seller.offers_as_seller

    offer.status = STATUS_ACCEPTED
    offer.save!

    # authorize credit card of buyer, 
    bt_result = Braintree::Transaction.submit_for_settlement

    # withdraw funds
  end

  def hold_in_escrow

  end

  def cancel
  end

end