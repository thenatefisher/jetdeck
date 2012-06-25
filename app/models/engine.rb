# == Schema Information
# Schema version: 20120429080558
#
# Table name: engines
#
#  id          :integer         not null, primary key
#  serial      :string(255)
#  label       :string(255)
#  totalTime   :integer
#  totalCycles :integer
#  year        :integer
#  smoh        :integer
#  tbo         :integer
#  type        :string(255)
#  hsi         :integer
#  shsi        :integer
#  model_id    :integer
#  baseline    :boolean
#  baseline_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Engine < ActiveRecord::Base

    belongs_to  :m,
                :class_name => "Equipment",
                :foreign_key => "model_id",
                :conditions => "etype = 'engines'"
              
    before_save :init

    belongs_to  :owner,
                :class_name => "User"    

    def init
        # baseline records should not have labels
        if (self.baseline == true)
            self.label = nil
        end
    end           

end
