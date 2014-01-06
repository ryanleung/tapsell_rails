class AddExpMonthToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :exp_month, :integer
  end
end
