class AddIndexToUsers < ActiveRecord::Migration
  def change
  add_index "users", ["contact_id"], :name => "indexusers_on_contact_id"
  end
end
