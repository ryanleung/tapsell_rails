class Message < ActiveRecord::Base

  belongs_to :message_chain
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"

  # Validations
  # -----------

  validates_presence_of :content,
                        :unless => Proc.new {|u| u.content.nil? }
  validates_length_of :content,
                      :within => 1..2000,
                      :too_short => "must be at least 1 character",
                      :too_long => "must be no more than 2000 characters",
                      :unless => Proc.new {|u| u.content.blank? || u.content.nil? }

  validates_presence_of :sender,
                        :unless => Proc.new {|u| u.sender.nil? }

  validates_presence_of :message_chain,
                        :unless => Proc.new {|u| u.message_chain.nil? }

end