class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :name
      t.text :description
      t.integer :min_year
      t.integer :max_year
      t.integer :min_tt
      t.integer :max_tt
      t.string :equipment_keywords
      t.string :model_keywords
      t.integer :min_price
      t.integer :max_price
      t.integer :contact_id # contact
      t.integer :user_id # agent who authored it
      t.boolean :listed
      t.boolean :damage # is any damage history acceptable
      t.integer :max_engine_tt      
      t.integer :min_engine_tt
      t.integer :max_engine_smoh    
      t.integer :min_engine_smoh      

      t.timestamps
    end
  end
end
