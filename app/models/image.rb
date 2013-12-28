class Image < ActiveRecord::Base
	# Relationships - Ordered Alphabetically
	# --------------------------------------

	belongs_to :listing
	belongs_to :user

  mount_uploader :image, ImageUploader
  
  validates_presence_of :image #, :title

end