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

ActiveRecord::Schema.define(:version => 20120313064834) do

  create_table "airframe_images", :force => true do |t|
    t.integer  "airframe_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "thumbnail"
    t.integer  "created_by"
  end

  create_table "airframe_messages", :force => true do |t|
    t.integer  "created_by"
    t.integer  "recipient_id"
    t.integer  "status_id"
    t.datetime "status_date"
    t.integer  "airframe_spec_id"
    t.integer  "airframe_id"
    t.boolean  "photos_enabled"
    t.boolean  "spec_enabled"
    t.string   "photos_url_code"
    t.string   "spec_url_code"
    t.text     "body"
    t.text     "subject"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "airframe_specs", :force => true do |t|
    t.integer  "created_by"
    t.string   "spec_file_name"
    t.string   "spec_content_type"
    t.integer  "spec_file_size"
    t.datetime "spec_updated_at"
    t.integer  "airframe_id"
    t.boolean  "enabled"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "airframes", :force => true do |t|
    t.string   "serial"
    t.string   "registration"
    t.string   "make"
    t.string   "model_name"
    t.integer  "year"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "created_by"
    t.integer  "asking_price"
    t.text     "description"
    t.text     "import_url"
  end

  create_table "contacts", :force => true do |t|
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.string   "company"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "phone"
    t.integer  "created_by"
    t.string   "website"
    t.integer  "sticky_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "invites", :force => true do |t|
    t.integer  "created_by"
    t.boolean  "activated"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
    t.string   "name"
    t.string   "email"
  end

  create_table "leads", :force => true do |t|
    t.integer  "airframe_id"
    t.integer  "created_by"
    t.integer  "contact_id"
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

  create_table "todos", :force => true do |t|
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

  create_table "users", :force => true do |t|
    t.integer  "type"
    t.integer  "contact_id"
    t.integer  "storage_quota"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "enabled"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "invites"
    t.string   "activation_token"
    t.boolean  "activated"
    t.string   "bookmarklet_token"
    t.text     "signature"
  end

  add_index "users", ["contact_id"], :name => "indexusers_on_contact_id"

end
