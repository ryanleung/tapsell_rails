class Listing < ActiveRecord::Base
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
	  results = find(:all, :order => 'created_at DESC', :conditions => ['title LIKE ? or info LIKE ?', "%#{search}%", "%#{search}%"])
	  return results
	end


	# Validations
	# -----------

	validates :seller_id,
				:presence => true
	validates :title,
				:presence => true

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