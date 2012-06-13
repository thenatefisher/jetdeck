# == Schema Information
# Schema version: 20120429080558
#
# Table name: airframes
#
#  id           :integer         not null, primary key
#  serial       :string(255)
#  registration :string(255)
#  model_id     :integer         indexed
#  year         :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  airport_id   :integer
#  user_id      :integer
#  baseline_id  :integer
#  baseline     :boolean
#  totalTime    :integer
#  totalCycles  :integer
#  askingPrice  :integer
#

class Airframe < ActiveRecord::Base

  # relationships
  has_many :airframe_equipments

  belongs_to :airport

  belongs_to  :m,
              :class_name => "Equipment",
              :foreign_key => "model_id",
              :conditions => "etype = 'airframes'"

  has_many    :engines,
              :through => :airframe_equipments,
              :foreign_key => "airframe_id",
              :class_name => "Engine",
              :source => :engine

  has_many    :equipment,
              :through => :airframe_equipments,
              :foreign_key => "airframe_id",
              :class_name => "Equipment",
              :source => :equipment,
              :conditions => "etype != 'engines'"

  has_many :accessories, :dependent => :destroy

  accepts_nested_attributes_for :accessories, :reject_if => lambda { |t| t['image'].nil? }

  has_many :xspecs, :dependent => :destroy

  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"

  has_many :histories, :class_name => 'AirframeHistory', :dependent => :destroy

  has_many :credits, :as => :creditable

  # accessor
  attr_accessor :model, :make, :leads, :thumbnail

  # hooks
  before_save :record_history

  # named scopes
  scope :reg, lambda { |r| where("registration like ?", r) }

  # validation
  validates_presence_of :m

  # methods
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

  def avatar

    avatars = {}
    assy = accessories.where(:thumbnail => true).first
    if assy.present?

        { :original => "/assets/airframes/#{assy.id}/original/#{assy.image_file_name}",
          :listing => "/assets/airframes/#{assy.id}/listing/#{assy.image_file_name}",
          :mini => "/assets/airframes/#{assy.id}/mini/#{assy.image_file_name}",
          :thumb => "/assets/airframes/#{assy.id}/thumb/#{assy.image_file_name}" }

    end


  end

  def make
    self.m.make.name if self.m.make
  end

  def model
    self.m.name
  end

  def shareWith
    # give another user read or write access to this airframe
  end

  def to_s
    retval = ''
    retval = self.year.to_s if self.year
    retval += " " + self.m.make.name if (self.m && self.m.make)
    retval += " " + self.m.name if self.m
    retval
  end

end
