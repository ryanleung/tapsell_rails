class CreateOffersTable < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :seller_id
      t.integer :listing_id
      t.integer :buyer_id
      t.integer :credit_card_id
      t.decimal :price
      t.string :status
      t.timestamps
    end

    add_index :offers, [:seller_id]
    add_index :offers, [:buyer_id]
    add_index :offers, [:listing_id]
  end
end
