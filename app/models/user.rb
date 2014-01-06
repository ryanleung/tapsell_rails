require 'bcrypt'

class User < ActiveRecord::Base

	include BCrypt

	# Attributes
	# ----------

	attr_accessor :password

	# Relationships - Ordered Alphabetically
	# --------------------------------------

	has_many :selling_listings, :class_name => "Listing", :foreign_key => :seller_id
  has_many :buying_listings, :class_name => "Listing", :foreign_key => :buyer_id
  has_one :image
  # Use the method message_chains to get all message chains for user
  has_many :seller_message_chains, :class_name => "MessageChain", :foreign_key => :seller_id
  has_many :buyer_message_chains, :class_name => "MessageChain", :foreign_key => :buyer_id

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
  		avatar_url: self.image.try(:image).try(:url),
      email: self.email,
  		location: self.location,
  		bio: self.bio,
  		rating: self.rating
  	}
  end

  # Instance Methods
  # -------------

  def initiate_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    Notifier.send_password_reset_email(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def message_chains
    msg_chains = self.seller_message_chains + self.buyer_message_chains
    return msg_chains.sort_by(&:updated_at)
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

    def new_remember_token
      SecureRandom.urlsafe_base64
    end

    def encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end

	end

  # Protected instance methods
  # --------------------------
  # protected

  # What are protected instance methods?

	# Private instance methods
	# ------------------------
	private

	def encrypt_password
    if password.present?
      self.password_hash = Password.create(password)
    end
  end

  def normalize_attributes
    [:first_name, :last_name, :email].each do |attr_name|
      self[attr_name] = self[attr_name].strip if self[attr_name].respond_to?(:strip)
    end
    self[:email] = self[:email].downcase if self[:email].respond_to?(:downcase)
  end

end
