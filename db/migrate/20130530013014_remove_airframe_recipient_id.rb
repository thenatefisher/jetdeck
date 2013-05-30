class RemoveAirframeRecipientId < ActiveRecord::Migration
  def up
    remove_column :airframes, :recipient_id
  end

  def down
  end
end
