class Address < ActiveRecord::Base
	# Relationships - Ordered Alphabetically
	# --------------------------------------



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
end