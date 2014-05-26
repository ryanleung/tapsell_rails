class Review < ActiveRecord::Base
  
  # Relationships
  # -------------
  
  belongs_to :user
  belongs_to :offer

end
