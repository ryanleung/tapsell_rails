class ListingImage < ActiveRecord::Base
	# Relationships - Ordered Alphabetically
	# --------------------------------------

	belongs_to :listing

	has_attached_file :listing_image,
		styles: {
			thumb: '100x100',
			square: '200x200',
			medium: '300x300'
		}

end