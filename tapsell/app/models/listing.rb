class Listing < ActiveRecord::Base
	# Relationships - Ordered Alphabetically
	# --------------------------------------

	belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
	has_one :address

	# Validations
	# -----------

	validates :seller_id,
				:presence => true
	validates :title,
				:presence => true

	def api_hash
		{
			listing_id: self.id,
			seller_id: self.seller_id,
			address: self.address.nil? ? nil : self.address.api_hash,
			title: self.title,
			category: self.category,
			date: self.created_at,
			info: self.info,
			price: self.price,
			status: self.status,
			pic_url: self.pic_url
		}
	end

end