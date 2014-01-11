# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140111070635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.integer  "listing_id"
    t.integer  "user_id"
    t.string   "street_address"
    t.string   "extended_address"
    t.string   "locality"
    t.string   "region"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_sessions", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "legal_first_name"
    t.string   "legal_last_name"
    t.integer  "birth_day"
    t.integer  "birth_month"
    t.integer  "birth_year"
    t.integer  "braintree_id"
    t.integer  "ending_digits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_type"
  end

  create_table "checks", force: true do |t|
    t.integer  "user_id"
    t.integer  "first_name"
    t.integer  "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", force: true do |t|
    t.string   "braintree_token"
    t.integer  "ending_digits"
    t.integer  "starting_digits"
    t.string   "card_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.integer  "user_id"
  end

  create_table "images", force: true do |t|
    t.string   "title"
    t.string   "image"
    t.integer  "bytes"
    t.integer  "user_id"
    t.integer  "listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", force: true do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.integer  "address_id"
    t.string   "title"
    t.string   "category"
    t.text     "info"
    t.boolean  "post_to_craigslist"
    t.boolean  "post_to_fb_timeline"
    t.boolean  "post_to_free_for_sale"
    t.decimal  "price"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", force: true do |t|
    t.integer  "listing_id"
    t.integer  "offer_amount"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "rating"
    t.text     "bio"
    t.text     "avatar_url"
    t.string   "password_hash"
    t.string   "email"
    t.string   "location"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "primary_card_id"
    t.integer  "braintree_id"
    t.integer  "primary_bank_id"
    t.integer  "primary_check_id"
    t.integer  "default_payout_type"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
