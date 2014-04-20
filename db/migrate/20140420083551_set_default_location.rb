class SetDefaultLocation < ActiveRecord::Migration
  def change
    change_column :users, :location, :string, default: "UC San Diego"
  end
end
