require 'bcrypt'

class User < ActiveRecord::Base

	include BCrypt

	# Attributes
	# ----------

	attr_accessor :password

	# Relationships - Ordered Alphabetically
	# --------------------------------------

	# Ryan, you should check this
  has_many :reviews_as_seller, :class_name => "Review", :foreign_key => :seller_id
  has_many :reviews_as_buyer, :class_name => "Review", :foreign_key => :buyer_id
  has_many :listings_as_seller, :class_name => "Listing", :foreign_key => :seller_id
  has_many :listings_as_buyer, :class_name => "Listing", :foreign_key => :buyer_id
  has_one :image
  has_one :address
  has_many :credit_cards
  has_many :recipients
  has_many :offers_as_seller, :class_name => "Offer", :foreign_key => :seller_id
  has_many :offers_as_buyer, :class_name => "Offer", :foreign_key => :buyer_id
  # Use the method message_chains to get all message chains for user
  has_many :message_chains_as_seller, :class_name => "MessageChain", :foreign_key => :seller_id
  has_many :message_chains_as_buyer, :class_name => "MessageChain", :foreign_key => :buyer_id

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
                      :maximum => 400,
                      :unless => Proc.new {|u| u.bio.blank?}

	# Callbacks
	# ---------

	before_validation :normalize_attributes
	before_save :encrypt_password
 
  # API-specific methods
  # --------------------

  def api_hash
  	{
      user_id: self.id,
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
    Notifier.delay.send_password_reset_email(self)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # Messages
  # ------------------------

  def message_chains
    msg_chains = self.message_chains_as_seller + self.message_chains_as_buyer
    return msg_chains.sort_by(&:updated_at)
  end

  def unread_message_chain_count
    count = 0
    message_chains.each do |m|
      if m.seller == self
        count = count + 1 if m.seller_dirty
      else
        count = count + 1 if m.buyer_dirty
      end
    end

    count
  end

  # Payments
  # ---------------------------

  # If one does not exist already, create and save a stripe customer id for
  # this [rails/AR] customer via a server-to-server Stripe API call. Return
  # the found or created stripe id, which is a string.
  def find_or_create_stripe_customer_id
    unless self.stripe_customer_id
      begin
        st_result = Stripe::Customer.create(
          email: self.email
        )
      rescue => e
        raise "Stripe errors: #{e.message}"
      end
      self.stripe_customer_id = st_result.id
      self.save!
    end
    self.stripe_customer_id
  end

  def default_credit_card
    return nil if self.credit_cards.empty?

    self.credit_cards.each do |c|
      if c.is_default?
        return c
      end
    end

    return nil
  end

  def default_recipient
    return nil if self.recipients.empty?

    self.recipients.each do |r|
      if r.is_default?
        return r
      end
    end

    return nil
  end

  # Reviews
  # ---------------------------

  def pos_reviews
    User.find_by_id(id).reviews_as_seller.sum(:positive)
  end

  def total_reviews
    User.find_by_id(id).reviews_as_seller.count
  end

  # This may automatically round the answer - need to check
  def percent_pos_reviews
    (pos_reviews * 100.0) / (total_reviews * 100.0)
  end

  # Listings
  # --------------------------

  def active_listings_as_seller
    active_listings = []
    listings_as_seller.order("created_at DESC").each do |l|
      if l.status == Listing::STATUS_ACTIVE || l.status == nil
        active_listings << l
      end
    end

    return active_listings
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
