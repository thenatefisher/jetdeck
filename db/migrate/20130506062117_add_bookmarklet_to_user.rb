class AddBookmarkletToUser < ActiveRecord::Migration
  def change
    add_column :users, :bookmarklet_token, :string
  end
end
