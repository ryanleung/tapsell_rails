class Offer < ActiveRecord::Base

  STATUS_WAITING_FOR_SELLER_RESPONSE = "waiting for seller response"
  STATUS_DENIED = "denied"
  STATUS_ACCEPTED = "accepted"
  STATUS_HALTED = "halted"
  STATUS_TRANSACTION_SUCCESSFUL = "transaction successful"
  STATUS_TRANSACTION_FAILED = "transaction failed"

  belongs_to :listing
  belongs_to :message_chain
  belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
  belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"
  belongs_to :credit_card

  def self.create_offer!(buyer, listing, cc=nil, price=nil)
    if price.present?
      p = price
    else
      p = listing.price
    end

    # if cc.present?
    #   credit_card = cc
    # else
    #   credit_card = buyer.default_credit_card
    # end

    offer = Offer.create!(
      seller: listing.seller,
      listing: listing,
      buyer: buyer,
      price: p,
      status: STATUS_WAITING_FOR_SELLER_RESPONSE,
      credit_card: nil,
    )

    offer
  end

  def self.accept_offer(seller, offer)
    raise "Seller does not own offer" if !seller.offers_as_seller.include? offer

    offer.status = STATUS_ACCEPTED
    offer.listing.sold_to(offer)
    offer.save!

    # TODO: this must be handled in two different flows, one where
    # user has a bank account, and thus we can just use escrow with braintree,
    # and one where we send the funds to our account to act as escrow if they
    # have not yet created a bank account (This method costs $0.25).
    # tapsell fee is price * %3.5
    # total = offer.price * 100 +  offer.price * 0.035 * 100
    # begin
    #   Stripe::Charge.create(
    #     amount: total.to_i,
    #     currency: "usd",
    #     customer: offer.buyer.stripe_customer_id,
    #     card: offer.credit_card.stripe_id,
    #     description: "Charge for seller with id #{seller.id} and offer id #{offer.id} for #{total}",
    #     statement_description: "Tapsell",
    #   )
    # rescue => e
    #   raise "Credit card charge error: #{e.message}"
    # end
  end

  def self.complete_offer(offer)
    offer.status = STATUS_TRANSACTION_SUCCESSFUL
    offer.save!

    begin
      Stripe::Transfer.create(
        amount: offer.price * 100,
        currency: "usd",
        recipient: offer.seller.default_recipient.stripe_id,
        description: "Tapsell",
      )
    rescue => e
      raise "Complete transfer error: #{e.message}"
    end
  end

  def cancel
    self.status = STATUS_DENIED

    # remove timers associated with offer
    Delayed::Job.where(queue: "offer_id$$$#{self.id}").destroy_all
    save
  end

  def set_accept_timers
    self.start_time_for_accepting = DateTime.now
    self.target_time_for_accepting = 1.day.from_now.end_of_day
    self.save!
  end

  def set_delivery_timers
    self.start_time_for_delivery = DateTime.now
    self.target_time_for_delivery = 3.days.from_now.end_of_day
    self.save!
  end

  def accept_timer_did_finish
    # If the offer is already accepted, then ignore.
    return if self.status == STATUS_ACCEPTED

    # If it hasn't, then decline the offer and send a declining message.
    self.cancel
    MessageChain.send_message(self.seller.id, self.listing.id, "#{self.seller.first_name.titleize} did not reply to the offer in time." , Message::TYPE_DEFAULT, self.message_chain.id, nil)
  end

  def initialize_accept_timer
    # Initialize timers on offer, check status in a day.
    self.set_accept_timers
    self.delay(run_at: 1.day.from_now.end_of_day, queue: "offer_id$$$#{self.id}").accept_timer_did_finish
  end

  def initialize_delivery_timer
    # Initialize timers on offer, check status in three days.
    self.set_delivery_timers
    self.delay(run_at: 3.days.from_now.end_of_day, queue: "offer_id$$$#{self.id}").delivery_timer_did_finish
  end

  def delivery_timer_did_finish
    # If the offer is halted, then just return.
    return if self.status == STATUS_HALTED

    # Otherwise, the offer is successful, send success message, send reviews
  end

end