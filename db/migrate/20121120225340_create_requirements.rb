class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :name
      t.integer :min_year
      t.integer :max_year
      t.integer :min_tt
      t.integer :max_tt
      t.string :equipment_keywords
      t.string :model_keywords
      t.integer :min_price
      t.integer :max_price
      t.integer :contact_id
      t.boolean :listed
      t.integer :max_engine_tt      
      t.integer :min_engine_tt
      t.integer :max_engine_smoh    
      t.integer :min_engine_smoh      

      t.timestamps
    end
  end
end
