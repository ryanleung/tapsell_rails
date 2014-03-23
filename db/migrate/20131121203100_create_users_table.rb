class CreateUsersTable < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :first_name
			t.string :last_name
			t.integer :rating
			t.text :bio
			t.string :password_hash
			t.string :email
			t.string :location
			t.string :phone_number
			t.decimal :credit
			t.integer :braintree_customer_id
			t.string :date_of_birth
			t.timestamps
		end
	end
end