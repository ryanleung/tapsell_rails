class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.integer :user_id
      t.string :legal_first_name
      t.string :legal_last_name
      t.integer :birth_day
      t.integer :birth_month
      t.integer :birth_year
      t.integer :braintree_id
      t.integer :ending_digits

      t.timestamps
    end
  end
end
