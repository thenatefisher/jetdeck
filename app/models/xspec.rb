class Xspec < ActiveRecord::Base

  has_many :views, :foreign_key => :spec_id, :class_name => "SpecView", :dependent => :destroy
  belongs_to :airframe
  belongs_to :recipient, :class_name => "Contact", :foreign_key => "recipient_id"
  belongs_to :sender, :class_name => "Contact", :foreign_key => "sender_id"

  before_save :unique_recipients_per_airframe

  before_create :generate_url_code

  belongs_to :xspec_background, :foreign_key => "background_id"

  validates_associated :airframe
  validates_associated :recipient
  validates_associated :sender

  attr_accessor :hits, :fire

  def unique_recipients_per_airframe

    if self.id.nil?
      if Xspec.where("recipient_id = ? AND airframe_id = ?", self.recipient, self.airframe).length > 0
        self.errors.add(:recipient, "Contact is already on the lead list for this airframe")
        false
      end
    else
      if Xspec.where("recipient_id = ? AND airframe_id = ? AND id != ?", self.recipient, self.airframe, self.id).length > 0
        self.errors.add(:recipient, "Contact is already on the lead list for this airframe")
        false
      end
    end

  end

  def send_spec
    XSpecMailer.sendRetail(self, self.recipient).deliver
  end

  def hits
    self.views.length
  end

  def fire

    recent_views = views.where("created_at > ?", Time.now - 24.hours).length

    false # return false if not on fire

    true if recent_views > 3

  end

  private

  # creates unique code for use as spec url
  def generate_url_code

    self.urlCode = create_code
    while (Xspec.where(:url_code => self.url_code).length > 0)
        self.url_code = create_code
    end

    # show the message by default
    self.show = true

  end

  def create_code
    BCrypt::Engine.generate_salt.gsub(/[^a-zA-Z0-9]+/, '').last(7)
  end

end
