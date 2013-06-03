class ChangeDisclaimerToSignatureInUser < ActiveRecord::Migration
  def up
    remove_column :users, :spec_disclaimer
    add_column :users, :signature, :text
  end

  def down
  end
end
