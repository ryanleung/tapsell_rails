class AddCheckIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :check_id, :integer
  end
end
