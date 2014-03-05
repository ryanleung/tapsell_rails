class SetDefault < ActiveRecord::Migration
  def change
    change_column :users, :location, :string, default: "UC Davis"
  end
end
