class AddSalutationToXspec < ActiveRecord::Migration
  def change
    add_column :xspecs, :salutation, :string

  end
end
