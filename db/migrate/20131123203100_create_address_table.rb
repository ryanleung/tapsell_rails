class CreateAddressTable < ActiveRecord::Migration
	def change
		create_table :addresses do |t|
			t.integer :listing_id
			t.integer :user_id
			t.string :street_address
			t.string :extended_address
			t.string :locality
			t.string :region
			t.string :postal_code
			t.string :phone
			t.string :email
			t.timestamps
		end
	end
end
