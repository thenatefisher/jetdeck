class Airframe < ActiveRecord::Base

  has_many :airframe_equipments

  belongs_to  :m,
              :class_name => "Equipment",
              :foreign_key => "model_id",
              :conditions => "etype = 'airframe'"

  has_many    :avionics,
              :through => :airframe_equipments,
              :foreign_key => "airframe_id",
              :class_name => "Equipment",
              :source => :equipment,
              :conditions => "equipment.etype = 'avionics'"

  has_many    :engines,
              :through => :airframe_equipments,
              :foreign_key => "airframe_id",
              :class_name => "Equipment",
              :source => :equipment,
              :conditions => "equipment.etype = 'engines'"

  has_many    :exteriors,
              :through => :airframe_equipments,
              :foreign_key => "airframe_id",
              :class_name => "Equipment",
              :source => :equipment,
              :conditions => "equipment.etype = 'exteriors'"

  has_many    :interiors,
              :through => :airframe_equipments,
              :foreign_key => "airframe_id",
              :class_name => "Equipment",
              :source => :equipment,
              :conditions => "equipment.etype = 'interiors'"

  has_many    :modifications,
              :through => :airframe_equipments,
              :foreign_key => "airframe_id",
              :class_name => "Equipment",
              :source => :equipment,
              :conditions => "equipment.etype = 'modifications'"

  has_many    :equipment,
              :through => :airframe_equipments,
              :foreign_key => "airframe_id",
              :class_name => "Equipment",
              :source => :equipment,
              :conditions => "equipment.etype = 'equipment'"

  has_many :xspecs, :dependent => :destroy

  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"

  has_many :histories, :class_name => 'AirframeHistory', :dependent => :destroy

  has_many :credits, :as => :creditable

  attr_accessor :model, :make

  before_save :record_history

  validates_presence_of :m

  def record_history
    self.changed.each do |c|
      event = AirframeHistory.create(
          :changeField=> c.to_s,
          :oldValue=> self.changes[c][0].to_s,
          :newValue=> self.changes[c][1].to_s)
      if event
        self.histories << event
      end
    end
  end

  scope :reg, lambda { |r| where("registration like ?", r) }

  def make
    self.m.make.name
  end

  def model
    self.m.name
  end

  def shareWith
    # give another user read or write access to this airframe
  end

  def to_s
    retval = self.year.to_s if self.year
    retval += " " + self.m.make.name if (self.m && self.m.make)
    retval += " " + self.m.name if self.m
    retval
  end

end
