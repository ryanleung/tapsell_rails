class ChangeRewardsTable < ActiveRecord::Migration
  def change
    remove_column :reviews, :buyer_id, :integer
    remove_column :reviews, :seller_id, :integer
    remove_column :reviews, :receiver_id, :integer
    remove_column :reviews, :positive, :integer

    add_column :reviews, :user_id, :integer, :null => false
    add_column :reviews, :rating, :integer, :null => false
    add_column :reviews, :offer_id, :integer
    add_column :reviews, :comment, :string

    add_index :reviews, [:user_id]
    add_index :reviews, [:offer_id]
  end
end
