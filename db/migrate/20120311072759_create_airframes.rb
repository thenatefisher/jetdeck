class CreateAirframes < ActiveRecord::Migration
  def change
    create_table :airframes do |t|
      t.string      :serial
      t.string      :registration
      t.string      :make
      t.string      :model_name
      t.integer     :year
      t.integer     :tt
      t.integer     :tc
      t.integer     :recipient_id
      t.integer     :sender_id
      t.timestamps
    end
  end
end
