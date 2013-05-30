class RemoveLoginsTable < ActiveRecord::Migration
  def up
    drop_table :logins
  end

  def down
  end
end
