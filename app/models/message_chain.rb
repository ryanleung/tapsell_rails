class MessageChain < ActiveRecord::Base

  has_many :messages
  belongs_to :seller, :class_name => "User", :foreign_key => :seller_id
  belongs_to :buyer, :class_name => "User", :foreign_key => :buyer_id

  # This is the main method that should be used when sending messages.
  # This method should be called in one of two ways:
  # 1. If msg_chain_id is nil, then this MUST mean that a buyer is 
  # sending a message to the seller about a listing for the first time.
  # listing_id then should not be nil.
  # 2. If msg_chain_id is not nil, then we can compare the sender_id
  # with the buyer or seller to see whether or not the sender is from
  # the buyer or seller.
  #
  # This method will return the newly created/updated message chain,
  # or nil if error in creating. 
  def self.send_message(sender_id, listing_id, msg_chain_id, content, type)
    msg_chain = nil
    if msg_chain_id.blank?
      # do a dummy check in case message chain exists
      listing = Listing.find_by_id(listing_id)
      msg_chain = MessageChain.find_or_create_by(:seller_id => listing.seller_id, :buyer_id => sender_id, :listing_id => listing_id)
    else
      msg_chain = MessageChain.find_by_id(msg_chain_id)
    end
    msg_chain.build_and_append_message(sender_id, content, type)
    return msg_chain
  end

  def api_hash(include_all_messages=false)
    messages = []
    if include_all_messages
      messages = self.messages
    else
      messages = self.most_recent_message
    end
    {
      listing: self.listing,
      seller: self.seller,
      buyer: self.buyer,
      seller_dirty: self.seller_dirty,
      buyer_dirty: self.buyer_dirty,
      messages: messages
    }
  end

  def build_and_append_message(sender_id, content, type)
    if sender_id != self.seller_id && sender_id != self.buyer_id
      raise "sender does not belong in this chain"
    end
    new_msg = Message.create(:content => content, :message_chain => self, :type => type, :sender_id => sender_id)
    self.messages.push(new_msg)
  end

  def most_recent_message
    self.messages.last
  end
end