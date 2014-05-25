class Listing < ActiveRecord::Base

  STATUS_ACTIVE = "active"
  STATUS_REMOVED = "removed"
  STATUS_PURCHASED = "purchased"
	# Relationships - Ordered Alphabetically
	# --------------------------------------

	has_one :address
	has_many :images
	has_many :offers
	has_many :message_chains
	belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
	belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"

	accepts_nested_attributes_for :images

	
  def self.search(search)
	  results = find(:all, :order => 'created_at DESC', :conditions => ['title ILIKE ? or info ILIKE ?', "%#{search}%", "%#{search}%"])
	  return results
	end

	def remove
	  # Change status of listing to removed, send deleted message
	  # to each message chain attached to the listing
    self.status = Listing::STATUS_REMOVED
    self.save

    self.message_chains.each do |m|
    	m.offer.cancel
      MessageChain.send_message(self.seller.id, self.id, "#{self.seller.first_name.titleize} has removed this listing.", Message::TYPE_LISTING_REMOVED, m.id, nil)
    end
	end

	def sold_to(offer)
	  # Change status of listing to sold, send deleted message
	  # to each message chain attached to the listing
    self.status = Listing::STATUS_PURCHASED
    self.save

    self.message_chains.each do |m|
    	m.offer.cancel if m.offer != offer
      MessageChain.send_message(self.seller.id, self.id, "#{self.seller.first_name.titleize} has sold this listing.", Message::TYPE_LISTING_SOLD, m.id, nil)
    end
	end


	# Validations
	# -----------

	validates :seller_id,
				:presence => true
	validates :title,
				:presence => { message: "is missing" }
	validates :price,
				:presence => { message: "is missing" }
	validates :info,
				:presence => { message: "is missing" }

	def api_hash
		images = []
		self.images.each do |i|
			images.push({ :url => i.image.url})
		end
		{
			listing_id: self.id,
			seller: self.seller.api_hash,
			# address: self.address.nil? ? nil : self.address.api_hash,
			title: self.title,
			category: self.category,
			date: self.created_at,
			info: self.info,
			price: self.price,
			status: self.status,
			images: images,
			locality: self.address.nil? ? nil : self.address.locality,
			region: self.address.nil? ? nil : self.address.region
		}
	end

end