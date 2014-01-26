class Check < ActiveRecord::Base

  # Relationships - Ordered Alphabetically
  # --------------------------------------

  belongs_to :user
  has_one :address

end
