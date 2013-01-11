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

ActiveRecord::Schema.define(:version => 20121120225340) do

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

  create_table "actions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "due_at"
    t.integer  "actionable_id"
    t.integer  "created_by"
    t.string   "actionable_type"
    t.boolean  "is_completed"
    t.datetime "completed_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
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
    t.string   "make"
    t.string   "model_name"
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
    t.integer  "asking_price"
    t.text     "description"
  end

  create_table "airports", :force => true do |t|
    t.string   "icao"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "name"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "alerts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "min_year"
    t.integer  "max_year"
    t.integer  "min_tt"
    t.integer  "max_tt"
    t.string   "equipment_keywords"
    t.string   "model_keywords"
    t.integer  "min_price"
    t.integer  "max_price"
    t.integer  "contact_id"
    t.integer  "user_id"
    t.boolean  "listed"
    t.boolean  "damage"
    t.integer  "max_engine_tt"
    t.integer  "min_engine_tt"
    t.integer  "max_engine_smoh"
    t.integer  "min_engine_smoh"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
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
    t.integer  "baseline_id"
    t.boolean  "baseline"
    t.string   "phone"
    t.integer  "owner_id"
    t.string   "website"
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

  create_table "details", :force => true do |t|
    t.string   "detailable_type"
    t.integer  "detailable_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "engines", :force => true do |t|
    t.string   "name"
    t.string   "serial"
    t.integer  "year"
    t.string   "make"
    t.string   "model_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.integer  "baseline_id"
    t.boolean  "baseline"
    t.integer  "tt"
    t.integer  "tc"
    t.integer  "smoh"
    t.integer  "shsi"
    t.integer  "tbo"
    t.integer  "hsi"
    t.integer  "airframe_id"
  end

  create_table "equipment", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.integer  "airframe_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "etype"
  end

  create_table "equipment_details", :force => true do |t|
    t.string   "value"
    t.string   "parameter"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "airframeEquipment_id"
  end

  create_table "invites", :force => true do |t|
    t.integer  "from_user_id"
    t.boolean  "activated"
    t.text     "message"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "token"
    t.string   "name"
    t.string   "email"
  end

  create_table "locations", :force => true do |t|
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.string   "registration_prefix"
    t.float    "salesTax"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "state_abbreviation"
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

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "created_by"
    t.string   "notable_type"
    t.integer  "notable_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "ownerships", :force => true do |t|
    t.integer  "contact_id"
    t.string   "assoc"
    t.integer  "created_by"
    t.string   "description"
    t.datetime "assigned"
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
    t.integer  "time_on_page"
    t.string   "agent"
    t.string   "ip"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "user_logos", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
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
    t.text     "spec_disclaimer"
    t.integer  "invites"
    t.string   "activation_token"
    t.boolean  "activated"
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
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "url_code"
    t.string   "salutation"
    t.string   "headline1"
    t.string   "headline2"
    t.string   "headline3"
    t.integer  "background_id"
    t.string   "override_price"
    t.text     "override_description"
    t.boolean  "show_message"
    t.boolean  "hide_price"
    t.boolean  "hide_serial"
    t.boolean  "hide_registration"
    t.boolean  "hide_location"
  end

end
