class CreateUsersTable < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :first_name
			t.string :last_name
			t.integer :rating
			t.text :bio
			t.text :avatar_url
			t.string :password_hash
			t.string :email
			t.references :address
			t.timestamps
		end
	end
end