# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Tapsell::Application.initialize!

# Point ActionMailer to Sendgrid servers
ActionMailer::Base.smtp_settings = {
  :user_name => 'vincent.tapsell',
  :password => 'Placeholder1230456!',
  :domain => 'tapsell.co',
  :address => 'smtp.sendgrid.net',
  :port => 587, #Change to port 465 for SSL connection
  :authentication => :plain,
  :enable_starttls_auto => true
}