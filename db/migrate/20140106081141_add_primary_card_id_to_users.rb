class AddPrimaryCardIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_card_id, :integer
  end
end
