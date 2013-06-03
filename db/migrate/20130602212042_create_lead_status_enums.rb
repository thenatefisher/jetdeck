class CreateLeadStatusEnums < ActiveRecord::Migration
  def change
    create_table :lead_status_enums do |t|
      t.string :status
    end
  end
end
