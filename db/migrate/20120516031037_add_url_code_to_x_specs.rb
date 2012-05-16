class AddUrlCodeToXSpecs < ActiveRecord::Migration
  def change
    add_column :xspecs, :urlCode, :string

  end
end
