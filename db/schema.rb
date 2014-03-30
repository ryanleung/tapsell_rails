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

ActiveRecord::Schema.define(version: 20140311070138) do

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

  create_table "credit_cards", force: true do |t|
    t.integer  "user_id"
    t.string   "stripe_id"
    t.integer  "address_id"
    t.string   "last_4",           limit: 4
    t.string   "card_type"
    t.integer  "expiration_month", limit: 2
    t.integer  "expiration_year"
    t.boolean  "is_default",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_cards", ["user_id"], name: "index_credit_cards_on_user_id", using: :btree

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

  create_table "message_chains", force: true do |t|
    t.integer  "buyer_id"
    t.integer  "seller_id"
    t.integer  "listing_id"
    t.boolean  "buyer_dirty",  default: false, null: false
    t.boolean  "seller_dirty", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "message_chain_id"
    t.integer  "sender_id"
    t.string   "message_type",     default: "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", force: true do |t|
    t.integer  "seller_id"
    t.integer  "listing_id"
    t.integer  "buyer_id"
    t.integer  "credit_card_id"
    t.decimal  "price"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offers", ["buyer_id"], name: "index_offers_on_buyer_id", using: :btree
  add_index "offers", ["listing_id"], name: "index_offers_on_listing_id", using: :btree
  add_index "offers", ["seller_id"], name: "index_offers_on_seller_id", using: :btree

  create_table "recipients", force: true do |t|
    t.integer  "user_id"
    t.string   "stripe_id"
    t.string   "last_4",     limit: 4
    t.boolean  "is_default",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipients", ["user_id"], name: "index_recipients_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "rating"
    t.text     "bio"
    t.string   "password_hash"
    t.string   "email"
    t.string   "location"
    t.string   "phone_number"
    t.decimal  "credit"
    t.string   "stripe_customer_id"
    t.string   "date_of_birth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
