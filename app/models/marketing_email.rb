class MarketingEmail < ActiveRecord::Base

# Validations
# -----------

  validates_uniqueness_of :email
  validates_presence_of :email

end
