class Listing < ActiveRecord::Base
	# Relationships - Ordered Alphabetically
	# --------------------------------------

	has_one :address
	has_many :images
	belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
	belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"

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
			seller_id: self.seller_id,
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