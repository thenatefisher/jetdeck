class Airframe < ActiveRecord::Base

  # relationships

  belongs_to :airport

  has_many    :engines,
              :foreign_key => "airframe_id",
              :class_name => "Engine"
              
  has_many    :equipment,
              :foreign_key => "airframe_id",
              :class_name => "Equipment"              

  has_many :accessories, :dependent => :destroy

  accepts_nested_attributes_for :accessories, :reject_if => lambda { |t| t['image'].nil? }

  has_many :xspecs, :dependent => :destroy

  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"

  def avatar

    avatars = {}
    assy = accessories.where(:thumbnail => true).first
    if assy.present?

        { :original => "http://s3.amazonaws.com/jetdeck/images/#{assy.id}/original/#{assy.image_file_name}",
          :listing => "http://s3.amazonaws.com/jetdeck/images/#{assy.id}/listing/#{assy.image_file_name}",
          :mini => "http://s3.amazonaws.com/jetdeck/images/#{assy.id}/mini/#{assy.image_file_name}",
          :thumb => "http://s3.amazonaws.com/jetdeck/images/#{assy.id}/thumb/#{assy.image_file_name}" }

    end

  end

  def to_s
    retval =   ''
    retval +=  self.year.to_s + " " if self.year
    retval +=  self.make + " " if self.make
    retval +=  self.model_name if self.model_name
    retval
  end

end
