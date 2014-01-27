class ChangeFirstNameFormatInChecks < ActiveRecord::Migration
  def up
    change_column :checks, :first_name, :string
  end

  def down
    change_column :checks, :first_name, :integer
  end
end
