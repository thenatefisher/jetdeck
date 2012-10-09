class AddInvitesToUser < ActiveRecord::Migration
  def change
    add_column :users, :invites, :integer

  end
end
