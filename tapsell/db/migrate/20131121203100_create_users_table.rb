class CreateUsersTable < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :username
			t.string :first_name
			t.string :last_name
			t.integer :rating
			t.string :bio
			t.string :avatar_url
			t.string :password_hash
			t.string :email
			t.references :address
			t.timestamps
		end
	end
end