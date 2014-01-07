class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_bank_id, :integer
    add_column :users, :primary_check_id, :integer
    add_column :users, :default_payout_type, :integer
  end
end
