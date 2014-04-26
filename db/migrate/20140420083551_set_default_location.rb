class SetDefaultLocation < ActiveRecord::Migration
  def self.up
    change_column :users, :location, :string, default: "UC San Diego"
  end

  def self.down
    change_column :users, :location, :string, default: "UC Davis"
  end
end
