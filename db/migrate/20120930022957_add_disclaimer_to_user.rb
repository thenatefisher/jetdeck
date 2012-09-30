class AddDisclaimerToUser < ActiveRecord::Migration
  def change
    add_column :users, :spec_disclaimer, :text

  end
end
