require "#{Rails.root}/app/models/lib/airframe_import_cdc"
require "#{Rails.root}/app/models/lib/airframe_import_aso"


class Airframe < ActiveRecord::Base

  extend AirframeImport

  # relationships
  has_many :actions, :as => :actionable
  
  has_many :notes, :as => :notable           

  has_many :accessories, :dependent => :destroy

  has_many :airframe_texts

  accepts_nested_attributes_for :airframe_texts

  accepts_nested_attributes_for :accessories, :reject_if => lambda { |t| t['image'].nil? }
  
  has_many :xspecs, :dependent => :destroy

  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"

  validates_uniqueness_of :import_url, :scope => :user_id,
                          :unless => Proc.new { |q| q.import_url.blank? }, 
                          :message => "Aircraft is already in deck."  

  def import(link=nil)
  
    # require a url and owner
    return nil if link.blank?

    # if already imported...
    return self if self.import_url == link

    self.import_url = link
    self.save!

    return self

  end

  def self.import(user_id=nil, link=nil)

    # require a url and owner
    return nil if link.blank? || user_id.blank? || User.find(user_id).blank?

    # if already imported...
    airframe = Airframe.where(:user_id => user_id, :import_url => link).first
    return airframe if airframe.present?

    # switch to correct parser
    case link
      when /[www\.]?controller\.com/
        airframe = delay.import_cdc(user_id, link)
      when /[www\.]?aso\.com/
        airframe = delay.import_aso(user_id, link)
      when /[www\.]?trade-a-plane\.com/
        #airframe = import_tap(user_id, link)
      else 
        airframe = nil    
    end

    return airframe

  end

  def search_url
    "/airframes/#{id}"
  end
  
  def search_desc
    self.to_s
  end
  
  def search_label
    label = self.serial
    if self.registration.present? && self.serial.present?
      label += " (#{self.registration.upcase})"
    else
      label = self.registration.upcase
    end
   
    label = "<i class=\"icon-plane\"></i> #{label}"
     
  end
  
  def avatar

    avatars = Hash.new()
    assy = accessories.where(:thumbnail => true).first
    if assy.present?

        { :original => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket + 
            "/images/#{assy.id}/original/#{assy.image_file_name}",
          :listing => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket +
            "/images/#{assy.id}/listing/#{assy.image_file_name}",
          :mini => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket +
            "/images/#{assy.id}/mini/#{assy.image_file_name}",
          :thumb => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket +
            "/images/#{assy.id}/thumb/#{assy.image_file_name}" }

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
