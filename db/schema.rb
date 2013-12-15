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

ActiveRecord::Schema.define(version: 20131124203100) do

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

  create_table "listing_images", force: true do |t|
    t.integer  "listing_id"
    t.text     "listing_image_remote_url"
    t.text     "listing_image_file_name"
    t.string   "listing_image_content_type"
    t.integer  "listing_image_file_size"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "download_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", force: true do |t|
    t.integer  "seller_id"
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

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "rating"
    t.text     "bio"
    t.text     "avatar_url"
    t.string   "password_hash"
    t.string   "email"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end