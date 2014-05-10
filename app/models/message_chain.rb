class MessageChain < ActiveRecord::Base

  has_many :messages
  has_one :offer
  belongs_to :listing
  belongs_to :seller, :class_name => "User", :foreign_key => :seller_id
  belongs_to :buyer, :class_name => "User", :foreign_key => :buyer_id

  # This is the main method that should be used when sending messages.
  # This method will create the message chain if it doesn't exist yet,
  # or append a message to an existing chain.
  # If the msg_chain doesn't exist, it means the sender is the buyer.
  def self.send_message(sender_id, listing_id, content, message_type, msg_chain_id, offer)
    seller_id = Listing.find_by_id(listing_id).seller_id

    # find out if message chain exists
    if msg_chain_id.present?
      msg_chain = MessageChain.find(msg_chain_id)
    else
      # TODO: This flow might not even be needed. The invariant is that the message chain
      # id will always be present when a seller is talking to a buyer. Another invariant
      # is that only the buyer can initiate messages. A user cannot (at least for now) just
      # send messages without a listing attached to it. Therefore, we can just check
      # if the msg_chain_id is present? and if it isn't, then we create one.
      msg_chain = MessageChain.find_by(:listing_id => listing_id, :seller_id => seller_id, :buyer_id => sender_id)
    end

    if msg_chain.nil?
      # handle case if msg_chain does not exist yet
      # the sender must be a seller if nil
      msg_chain = MessageChain.create(:listing_id => listing_id, :seller_id => seller_id, :buyer_id => sender_id, :offer => offer)
    end

    msg_chain.build_and_append_message(sender_id, content, message_type)
    return msg_chain
  end

  def api_hash(include_all_messages=false)
    messages = []
    if include_all_messages
      messages = self.messages
    else
      messages.push(self.most_recent_message)
    end
    {
      msg_chain_id: self.id,
      listing: self.listing,
      seller: self.seller.api_hash,
      buyer: self.buyer.api_hash,
      seller_dirty: self.seller_dirty,
      buyer_dirty: self.buyer_dirty,
      messages: messages.map { |m| m.api_hash }
    }
  end

  def build_and_append_message(sender_id, content, message_type)
    if sender_id != self.seller_id && sender_id != self.buyer_id
      raise "sender does not belong in this chain"
    end
    new_msg = Message.create(:content => content, :message_chain => self, :message_type => message_type, :sender_id => sender_id)
    self.messages.push(new_msg)
    self.seller_dirty = true
    self.buyer_dirty = true
    save!
    touch
  end

  def most_recent_message
    self.messages.last
  end
end