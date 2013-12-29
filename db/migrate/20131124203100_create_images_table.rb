class CreateImagesTable < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :image
      t.integer :bytes
      t.integer :user_id
      t.integer :listing_id

      t.timestamps
    end
  end
end