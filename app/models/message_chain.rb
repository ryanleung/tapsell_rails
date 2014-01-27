class MessageChain < ActiveRecord::Base

  has_many :messages
  belongs_to :listing
  belongs_to :seller, :class_name => "User", :foreign_key => :seller_id
  belongs_to :buyer, :class_name => "User", :foreign_key => :buyer_id

  # This is the main method that should be used when sending messages.
  # This method will create the message chain if it doesn't exist yet,
  # or append a message to an existing chain.
  # If the msg_chain doesn't exist, it means the sender is the buyer.
  def self.send_message(sender_id, listing_id, content, message_type)
    seller_id = Listing.find_by_id(listing_id).seller_id

    # find out if message chain exists
    msg_chain = MessageChain.find_by(:listing_id => listing_id, :seller_id => seller_id)

    if msg_chain.nil?
      # handle case if msg_chain does not exist yet
      # the sender must be a seller if nil
      msg_chain = MessageChain.create(:listing_id => listing_id, :seller_id => seller_id, :buyer_id => sender_id)
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
      seller: self.seller,
      buyer: self.buyer,
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
  end

  def most_recent_message
    self.messages.last
  end
end