class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :braintree_token
      t.integer :ending_digits
      t.integer :starting_digits
      t.string :card_type

      t.timestamps
    end
  end
end
