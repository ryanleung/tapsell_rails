class CreateMessagesTable < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
  		t.string :content
  		t.integer :message_chain_id
  		t.integer :sender_id
  		t.string :type, :null => "default", :default => "default"
  		t.timestamps
  	end

  	create_table :message_chains do |t|
  		t.integer :buyer_id
  		t.integer :seller_id
  		t.integer :listing_id
  		t.boolean :buyer_dirty, :null => false, :default => false
  		t.boolean :seller_dirty, :null => false, :default => false
  		t.timestamps
  	end
  end
end
