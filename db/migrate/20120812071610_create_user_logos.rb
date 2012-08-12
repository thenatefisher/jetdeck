class CreateUserLogos < ActiveRecord::Migration
  def change
    create_table :user_logos do |t|
      t.integer :user_id
      t.timestamps
    end
    
    add_column :user_logos, :image_file_name, :string
    add_column :user_logos, :image_content_type, :string
    add_column :user_logos, :image_file_size, :integer
    add_column :user_logos, :image_updated_at, :datetime

  end
end
