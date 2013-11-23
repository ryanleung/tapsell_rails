class Listing < ActiveRecord::Base
	# Relationships - Ordered Alphabetically
	# --------------------------------------

	has_one :address

	# Validations
	# -----------

	validates :seller_id,
				:presence => true
	validates :title,
				:presence => true

end