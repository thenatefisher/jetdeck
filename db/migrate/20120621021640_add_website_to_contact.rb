class AddWebsiteToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :website, :string

  end
end
