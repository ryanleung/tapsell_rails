class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.integer :user_id
      t.integer :first_name
      t.integer :last_name

      t.timestamps
    end
  end
end
