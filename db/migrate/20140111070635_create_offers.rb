class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :listing_id
      t.integer :offer_amount
      t.boolean :accepted

      t.timestamps
    end
  end
end
