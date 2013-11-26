require 'bcrypt'

class User < ActiveRecord::Base

	include BCrypt

	# Attributes
	# ----------

	attr_accessor :password

	# Relationships - Ordered Alphabetically
	# --------------------------------------

	has_one :address
	has_many :listings
	has_many :message_chains
	has_many :messages,
	:through => :message_chains

	# Validations
	# -----------

	validates_presence_of :password,
											:unless => Proc.new {|u| u.password.nil? }
  validates_length_of :password,
                      :within => 6..40,
                      :too_short => "must be at least 6 characters",
                      :too_long => "must be no more than 40 characters",
                      :unless => Proc.new {|u| u.password.blank? || u.password.nil? }
  validates :password,
            :format => {:with => /\A[[:alnum:][:punct:]<>\*\^\+\=\`\~]+\z/,
                        :message => 'can only contain letters and numbers'},
            :unless => Proc.new {|u| u.password.blank? || u.password.nil? }

  validates_confirmation_of :password, unless: 'password_confirmation.nil?'
  validates :username,
            :presence => { :message => "can't be blank" }
  validates_length_of :username,
                      :within => 3..64,
                      :unless => Proc.new {|u| u.username.blank?}
  validates_format_of :username,
                      :with => /\A[a-z0-9\-\._]+\z/i,
                      :message => "can't contain those characters",
                      :unless => Proc.new {|u| u.username.blank?}
  validate :begins_ends_alphanumeric,
                      :unless => Proc.new {|u| u.username.blank?}
  validate :username_is_not_a_route,
                      :unless => Proc.new {|u| u.username.blank?}
  validates_uniqueness_of :username,
                      :unless => Proc.new {|u| u.username.blank?},
                      :case_sensitive => false

  validates_uniqueness_of :email
  validates_presence_of :email
  validates_length_of :email,
                      :within => 1..255,
                      :unless => Proc.new { |u| u.email.blank? }
  validates :email,
            :email => true,
            :unless => Proc.new { |u| u.email.blank? }

  validates_presence_of :first_name
  validates_length_of :first_name,
                      :within => 1..255,
                      :unless => Proc.new {|u| u.first_name.blank?}
  validates_presence_of :last_name
  validates_length_of :last_name,
                      :within => 1..255,
                      :unless => Proc.new {|u| u.last_name.blank?}

  validates_length_of :bio,
                      :maximum => 150,
                      :unless => Proc.new {|u| u.bio.blank?}

	# Callbacks
	# ---------

	before_validation :normalize_attributes
	before_save :encrypt_password

  # API-specific methods
  # --------------------

  def api_hash
  	{
  		first_name: self.first_name,
  		last_name: self.last_name,
  		username: self.user_name,
  		avatar_url: self.avatar_url,
  		city: self.address.city,
  		state: self.address.state,
  		bio: self.bio,
  		rating: self.rating
  	}
  end

	# Class Methods
	# -------------

	class << self

		def authenticate(email, input_password)
			user = User.find_by_email(email)
			begin
				if user && BCrypt::Password.new(user.password_hash) == input_password
					return user
				else
					return nil
				end
			rescue BCrypt::Errors::InvalidHash => e
        # The correct approach here would be to redirect to an error page that forces a password reset
        return nil
      end
    end

	end

  # Protected instance methods
  # --------------------------
  protected

  def upper_username_is_unique
    unless User.where_username_is(self.username).empty?
      errors.add(:username, "has already been taken")
    end
  end

  def username_is_not_a_route
    path = Rails.application.routes.recognize_path("/#{username}", :method => :get) rescue nil
    errors.add(:username, "has already been taken") if path && !path[:username]
  end

  def begins_ends_alphanumeric
    unless self.username =~ (/^[a-z0-9][a-z0-9_.\-]+[a-z0-9]$/i)
      errors.add(:username, "must begin and end with an alphanumeric character")
    end
  end

	# Private instance methods
	# ------------------------
	private

	 def encrypt_password’
    if password.present?
      self.password_hash = Password.create(password)
    end
  end

  def normalize_attributes
    [:username, :first_name, :last_name, :email].each do |attr_name|
      self[attr_name] = self[attr_name].strip if self[attr_name].respond_to?(:strip)
    end
    self[:email] = self[:email].downcase if self[:email].respond_to?(:downcase)
  end

end
