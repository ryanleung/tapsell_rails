class SetDefault < ActiveRecord::Migration
  def self.up
    change_column :users, :location, :string, default: "UC Davis"
  end

  def self.down
    change_column :users, :location, :string
  end
end
