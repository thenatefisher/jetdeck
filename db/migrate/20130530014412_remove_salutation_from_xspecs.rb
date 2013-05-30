class RemoveSalutationFromXspecs < ActiveRecord::Migration
  def up
    remove_column :xspecs, :salutation
  end

  def down
  end
end
