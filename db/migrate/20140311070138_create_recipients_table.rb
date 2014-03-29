class CreateRecipientsTable < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.integer :user_id
      t.string :stripe_id
      t.string :last_4, :limit => 4
      t.boolean :is_default, :default => false
      t.timestamps
    end

    add_index :recipients, [:user_id]
  end
end
