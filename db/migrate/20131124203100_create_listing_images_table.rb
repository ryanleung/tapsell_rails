class CreateListingImagesTable < ActiveRecord::Migration
	def change
		create_table :listing_images do |t|
			t.integer :listing_id
			t.text :listing_image_remote_url
	    t.text :listing_image_file_name
	    t.string :listing_image_content_type
	    t.integer :listing_image_file_size
	    t.integer  :width
	    t.integer  :height
	    t.boolean  :download_failed
	    t.timestamps
	  end
	end
end
