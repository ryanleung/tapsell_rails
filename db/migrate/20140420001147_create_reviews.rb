class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.integer :receiver_id
      t.integer :positive

      t.timestamps
    end
  end
end
