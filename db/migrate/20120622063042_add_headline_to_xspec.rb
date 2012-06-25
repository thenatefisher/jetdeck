class AddHeadlineToXspec < ActiveRecord::Migration
  def change
    add_column :xspecs, :headline1, :string

    add_column :xspecs, :headline2, :string

    add_column :xspecs, :headline3, :string

  end
end
