class CreateCreditCardsTable < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.integer :user_id
      t.string :stripe_id
      t.integer :address_id
      t.string :last_4, :limit => 4
      t.string :card_type
      t.integer :expiration_month, :limit => 2
      t.integer :expiration_year, :limit => 4
      t.boolean :is_default, :default => false
      t.timestamps
    end

    add_index :credit_cards, [:user_id]
  end
end
