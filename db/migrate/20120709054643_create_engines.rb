class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
    
        t.string    :name
        t.string    :serial
        t.integer   :year
        t.string    :make
        t.string    :model_name
        t.datetime  :created_at,   :null => false
        t.datetime  :updated_at,   :null => false

        t.integer   :user_id
        t.integer   :baseline_id
        t.boolean   :baseline
        
        t.integer   :tt
        t.integer   :tc
        t.integer   :smoh
        t.integer   :shsi
        t.integer   :tbo
        t.integer   :hsi

      t.timestamps
    end
  end
end