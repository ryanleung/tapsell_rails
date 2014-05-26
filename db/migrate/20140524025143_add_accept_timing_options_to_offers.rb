class AddAcceptTimingOptionsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :start_time_for_accepting, :datetime
    add_column :offers, :target_time_for_accepting, :datetime
    add_column :offers, :start_time_for_delivery, :datetime
    add_column :offers, :target_time_for_delivery, :datetime
    add_column :offers, :disabled, :boolean, default: false
  end
end
