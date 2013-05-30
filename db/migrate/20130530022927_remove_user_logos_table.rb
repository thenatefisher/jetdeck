class RemoveUserLogosTable < ActiveRecord::Migration
  def up
        drop_table :user_logos
  end

  def down
  end
end
