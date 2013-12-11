class ApiSession < ActiveRecord::Base
	belongs_to :user
	before_save :create_token

	private

	def create_token
		self.token = SecureRandom.urlsafe_base64
	end
end