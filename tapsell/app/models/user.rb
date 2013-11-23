class User < ActiveRecord::Base

	# Relationships - Ordered Alphabetically
	# --------------------------------------

	has_one :address
	has_many :listings
	has_many :message_chains
	has_many :messages,
	:through => :message_chains

	# Validations
	# -----------

	validates :username,
	:presence => true,
	:uniqueness => true

	validates :first_name,
	:presence => true

	validates :last_name,
	:presence => true




end