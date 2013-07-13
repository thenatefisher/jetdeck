require "#{Rails.root}/app/models/lib/airframe_import_cdc"
require "#{Rails.root}/app/models/lib/airframe_import_aso"

class Airframe < ActiveRecord::Base

  extend AirframeImport

  attr_accessor :new_import

  # relationships
  has_many :todos, :foreign_key => :actionable_id, :as => :actionable, :dependent => :destroy
  accepts_nested_attributes_for :todos

  has_many :notes, :as => :notable, :dependent => :destroy
  accepts_nested_attributes_for :notes

  has_many :images, :class_name => "AirframeImage", :conditions => "image_file_name is not null", :dependent => :destroy
  accepts_nested_attributes_for :images

  has_many :specs, :class_name => "AirframeSpec", :conditions => "spec_file_name is not null", :dependent => :destroy
  accepts_nested_attributes_for :specs

  has_many :leads, :dependent => :destroy

  validates_uniqueness_of :import_url, :scope => :created_by,
    :message => "has already been imported", :on => :create, :if => "import_url.present?"

  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  validates_associated :creator
  validates_presence_of :creator
  validate :airframes_available, :on => :create
  

  # do not edit/create if user is delinquent
  validate :creator_account_current
  def creator_account_current
    if self.creator.delinquent?
      self.errors.add :base, "Your account is not current. Please update subscription payment information."
    end
  end

  # do not create if user is over quota
  def airframes_available
    if self.creator && self.creator.over_airframes_quota?
      self.errors.add :base, "Please <a href='/profile'>upgrade your account</a> to create more aircraft."
    end
  end

  def import(link=nil)

    # use link if supplied
    self.import_url = link if link.present?
    # otherwise use import url already attached
    return nil if self.import_url.blank?
    # import that machine data
    return Airframe::select_parser(self)

  end

  def self.import(user_id=nil, link=nil)

    # require a url and owner
    return nil if link.blank? || user_id.blank? || User.find(user_id).blank?

    # if already imported...
    airframe = Airframe.where(:created_by => user_id, :import_url => link).first
    if airframe.blank?
      # create location for imported data
      airframe = Airframe.create(:created_by => user_id, :import_url => link, :model_name => "Importing Data...")
      airframe.new_import = true # used to not override airframe details and only import images
    end

    if airframe.valid?
      return Airframe::select_parser(airframe)
    else
      return airframe
    end
  end

  # the aircraft default thumbnail
  def avatar
    image = images.where(:thumbnail => true).first 
    if image.present?
    { :original => image.url("original"),
      :listing => image.url("listing"),
      :mini => image.url("mini"),
      :thumb => image.url("thumb") }
    end
  end

  def to_s
    retval =  ""
    retval +=  self.year.to_s + " " if self.year.present?
    retval +=  self.make + " " if self.make.present?
    retval +=  self.model_name if self.model_name.present?
    return (retval.present?) ? retval : "Unidentified Aircraft"
  end

  def long
    retval =  ""
    retval +=  self.year.to_s + " " if self.year.present?
    retval +=  self.make + " " if self.make.present?
    retval +=  self.model_name if self.model_name.present?
    retval +=  " SN:#{self.serial}" if self.serial.present?
    retval +=  " (#{self.registration})" if self.registration.present?
    return (retval.present?) ? retval : "Unidentified Aircraft"
  end

  private 

  def self.select_parser(airframe)

    return nil if airframe.blank? || airframe.import_url.blank?

    # switch to correct parser
    case airframe.import_url
      when /[www\.]?controller\.com/
          import_cdc(airframe)
      when /[www\.]?aso\.com/
          import_aso(airframe)
      else
        airframe.destroy
        airframe.errors.add :base, "No aircraft found at that location"
    end

    # create the airframe for immediate use
    if airframe.present? 
      airframe.save! if !airframe.destroyed? 
      # return the airframe that will be loaded with import data
      return airframe
    end

  end

end
