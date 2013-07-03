class AirframeMessage < ActiveRecord::Base

  belongs_to :airframe
  belongs_to :airframe_spec
  belongs_to :creator, :foreign_key => :created_by, :class_name => "User"
  belongs_to :recipient, :foreign_key => :recipient_id, :class_name => "Contact"

  validates_presence_of :subject
  validates_associated :airframe
  validates_presence_of :airframe
  validates_associated :recipient
  validates_presence_of :recipient
  validates_associated :creator
  validates_presence_of :creator

  before_create :init
  validate :require_user_activation

  def init
    self.status_id ||= 0
    self.status_date ||= Time.now()
    self.photos_enabled ||= true
    self.spec_enabled ||= true
    generate_url_codes()
    nil
  end

  def send_message
    success = false
    if self.creator.activated && self.airframe_spec && self.airframe_spec.enabled
      success = AirframeMessageMailer.sendMessage(self).deliver
    end
    return success
  end

  # Sent, Bounced, Opened, Downloaded
  def status
    case status_id
    when 1; "Sending"
    when 2; "Sent"
    when 3; "Bounced"
    when 4; "Opened"
    when 5; "Downloaded"
    when 6; "Send Failed"
    else;   "Unknown"
    end
  end

  def status=(code)

    new_status_id = self.status_id

    case code.downcase
    when "sending";      new_status_id = 1
    when "sent";         new_status_id = 2
    when "bounced";      new_status_id = 3
    when "opened";       new_status_id = 4
    when "downloaded";   new_status_id = 5
    when "failed";       new_status_id = 6
    else;                new_status_id = 0
    end

    if new_status_id != self.status_id
      status_date = Time.now()
      self.status_id = new_status_id
    end

  end

  private

    # creates unique code for use as spec url
    def generate_url_codes

      self.spec_url_code = create_code
      while (AirframeMessage.where(:spec_url_code => self.spec_url_code).count > 0)
        self.spec_url_code = create_code
      end

      self.photos_url_code = create_code
      while (AirframeMessage.where(:photos_url_code => self.photos_url_code).count > 0)
        self.photos_url_code = create_code
      end

    end

    def create_code
      BCrypt::Engine.generate_salt.gsub(/[^a-zA-Z0-9]+/, "").last(7)
    end

    def require_user_activation
      if !self.creator || self.creator.activated != true
        self.errors.add(:base, "Sending disabled pending <a href='/profile'>account verification</a>.")
        false
      end
    end


end
