class Address < ActiveRecord::Base
	# Relationships - Ordered Alphabetically
	# --------------------------------------

	belongs_to :listing
	belongs_to :user

	# Validations
	# -----------

	validates :street_address,
					:presence => true
	validates :locality,
					:presence => true
	validates :region,
					:presence => true
	validates :postal_code,
					:presence => true

	def api_hash
		{
			address_id: self.id,
			street_address: self.street_address,
			extended_address: self.extended_address,
			locality: self.locality,
			region: self.region,
			postal_code: self.postal_code,
			phone: self.phone,
			email: self.email
		}
	end
end