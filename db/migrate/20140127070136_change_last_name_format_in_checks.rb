class ChangeLastNameFormatInChecks < ActiveRecord::Migration
  def up
    change_column :checks, :last_name, :string
  end

  def down
    change_column :checks, :last_name, :integer
  end
end
