class ChangeReviewsRatingNullField < ActiveRecord::Migration
  def up
    remove_column :reviews, :user_id, :integer
    change_column :reviews, :rating, :integer, :null => true
    add_column :reviews, :reviewer_id, :integer
    add_column :reviews, :reviewee_id, :integer
  end

  def down
    add_column :reviews, :user_id, :integer
    change_column :reviews, :rating, :integer, :null => false
    remove_column :reviews, :reviewer_id, :integer
    remove_column :reviews, :reviewee_id, :integer
  end
end
