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

ActiveRecord::Schema.define(:version => 20120517032746) do

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

  create_table "airframe_contacts", :force => true do |t|
    t.integer  "airframe_id"
    t.integer  "contact_id"
    t.string   "relation"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "airframe_equipments", :force => true do |t|
    t.integer  "airframe_id"
    t.integer  "equipment_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "engine_id"
  end

  create_table "airframe_histories", :force => true do |t|
    t.integer  "airframe_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
    t.text     "oldValue"
    t.text     "newValue"
    t.string   "changeField"
  end

  add_index "airframe_histories", ["user_id"], :name => "index_airframe_histories_on_user_id"

  create_table "airframes", :force => true do |t|
    t.string   "serial"
    t.string   "registration"
    t.integer  "model_id"
    t.integer  "year"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "airport_id"
    t.integer  "user_id"
    t.integer  "baseline_id"
    t.boolean  "baseline"
    t.integer  "totalTime"
    t.integer  "totalCycles"
    t.integer  "askingPrice"
  end

  add_index "airframes", ["model_id"], :name => "index_airframes_on_model_id"

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
  end

  create_table "credits", :force => true do |t|
    t.integer  "user_id"
    t.string   "creditable_type"
    t.integer  "creditable_id"
    t.decimal  "amount"
    t.boolean  "direction"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "credits", ["user_id"], :name => "index_credits_on_user_id"

  create_table "engines", :force => true do |t|
    t.string   "serial"
    t.integer  "totalTime"
    t.integer  "totalCycles"
    t.integer  "year"
    t.integer  "smoh"
    t.integer  "tbo"
    t.integer  "hsi"
    t.integer  "shsi"
    t.integer  "model_id"
    t.boolean  "baseline"
    t.integer  "baseline_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "label"
  end

  create_table "equipment", :force => true do |t|
    t.integer  "manufacturer_id"
    t.string   "abbreviation"
    t.string   "modelNumber"
    t.string   "name"
    t.text     "description"
    t.string   "etype"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "equipment", ["manufacturer_id"], :name => "index_equipment_on_manufacturer_id"

  create_table "equipment_details", :force => true do |t|
    t.string   "value"
    t.string   "parameter"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "airframeEquipment_id"
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

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "spec_permissions", :force => true do |t|
    t.integer  "spec_id"
    t.string   "field"
    t.boolean  "allowed"
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
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "active"
  end

  add_index "users", ["contact_id"], :name => "indexusers_on_contact_id"

  create_table "xspecs", :force => true do |t|
    t.integer  "airframe_id"
    t.integer  "recipient"
    t.integer  "sender"
    t.datetime "sent"
    t.string   "format"
    t.text     "message"
    t.boolean  "published"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "urlCode"
  end

end
