class CreateMerchantAccountsTable < ActiveRecord::Migration
  def change
    create_table :merchant_accounts do |t|
      t.integer :user_id
      t.string :braintree_token
      t.integer :address_id
      t.string :last_4, :limit => 4
      t.boolean :is_default, :default => false
      t.timestamps
    end

    add_index :merchant_accounts, [:user_id]
  end
end
