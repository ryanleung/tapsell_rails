class CreateListingsTable < ActiveRecord::Migration
	def change
		create_table :listings do |t|
			t.integer :seller_id
			t.references :address
			t.string :title
			t.string :category
			t.text :info
			t.boolean :post_to_craigslist
			t.boolean :post_to_fb_timeline
			t.boolean :post_to_free_for_sale
			t.decimal :price
			t.string :status
			t.timestamps
		end
	end
end
