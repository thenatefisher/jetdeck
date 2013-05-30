class RemoveAirframeSenderId < ActiveRecord::Migration
  def up
    remove_column :airframes, :sender_id
  end

  def down
  end
end
