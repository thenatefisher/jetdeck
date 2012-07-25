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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120722175738) do

  create_table "accessories", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "airframe_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.boolean  "thumbnail"
  end

  create_table "addresses", :force => true do |t|
    t.integer  "location_id"
    t.string   "postal"
    t.integer  "contact_id"
    t.string   "label"
    t.text     "description"
    t.string   "line1"
    t.string   "line2"
    t.string   "line3"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "airframes", :force => true do |t|
    t.string   "serial"
    t.string   "registration"
    t.string   "make"
    t.string   "modelName"
    t.integer  "year"
    t.integer  "tt"
    t.integer  "tc"
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "airport_id"
    t.integer  "user_id"
    t.integer  "baseline_id"
    t.boolean  "baseline"
    t.integer  "askingPrice"
  end

  create_table "airports", :force => true do |t|
    t.string   "icao"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "location_id"
  end

  create_table "contacts", :force => true do |t|
    t.string   "first"
    t.string   "last"
    t.string   "source"
    t.string   "email"
    t.string   "company"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.integer  "baseline_id"
    t.boolean  "baseline"
    t.string   "phone"
    t.integer  "owner_id"
    t.string   "website"
  end

  create_table "engines", :force => true do |t|
    t.string   "name"
    t.string   "serial"
    t.integer  "year"
    t.string   "make"
    t.string   "modelName"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.integer  "baseline_id"
    t.boolean  "baseline"
    t.integer  "ttsn"
    t.integer  "tcsn"
    t.integer  "smoh"
    t.integer  "shsi"
    t.integer  "tbo"
    t.integer  "hsi"
    t.integer  "airframe_id"
  end

  create_table "equipment", :force => true do |t|
    t.string   "type"
    t.string   "title"
    t.string   "name"
    t.integer  "airframe_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.string   "registrationPrefix"
    t.float    "salesTax"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "stateAbbreviation"
  end

  create_table "logins", :force => true do |t|
    t.integer  "user_id"
    t.string   "agent"
    t.string   "ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spec_views", :force => true do |t|
    t.integer  "spec_id"
    t.integer  "timeOnPage"
    t.string   "agent"
    t.string   "ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "type"
    t.integer  "contact_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "active"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["contact_id"], :name => "indexusers_on_contact_id"

  create_table "xspec_backgrounds", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "xspecs", :force => true do |t|
    t.integer  "airframe_id"
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.datetime "sent"
    t.string   "format"
    t.text     "message"
    t.boolean  "published"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "urlCode"
    t.string   "salutation"
    t.boolean  "show"
    t.string   "headline1"
    t.string   "headline2"
    t.string   "headline3"
    t.integer  "background_id"
  end

end
