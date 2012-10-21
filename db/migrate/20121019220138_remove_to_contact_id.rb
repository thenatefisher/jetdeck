class RemoveToContactId < ActiveRecord::Migration
  def up
    remove_column :invites, :to_contact_id
  end

  def down
  end
end
