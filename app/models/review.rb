class Review < ActiveRecord::Base
  
  # Relationships
  # -------------
  
  belongs_to :reviewer, :class_name => "User", :foreign_key => "reviewer_id"
  belongs_to :reviewee, :class_name => "User", :foreign_key => "reviewee_id"
  belongs_to :offer

end
