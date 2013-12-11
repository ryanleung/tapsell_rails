# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
# 
# For Heroku
Tapsell::Application.config.secret_token = ENV['SECRET_TOKEN']

Tapsell::Application.config.secret_key_base = '0367339da94597f458a19bc098f00ad129610e2d6169112342d8b2858a93036d87b017217c7aa1ccee25437331df249b38c51cc8bc9b09142b2b8d94541ce469'
