class AddExpYearToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :exp_year, :integer
  end
end
