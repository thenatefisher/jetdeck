class RemoveHeadlinesFromXspecs < ActiveRecord::Migration
  def up
    remove_column :xspecs, :headline1
    remove_column :xspecs, :headline2
    remove_column :xspecs, :headline3
  end

  def down
  end
end
