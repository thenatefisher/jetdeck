class Lead < ActiveRecord::Base

  belongs_to :spec, :foreign_key => :spec_id, :class_name => "Accessory"
  belongs_to :airframe
  belongs_to :recipient, :class_name => "Contact", :foreign_key => "recipient_id"
  belongs_to :sender, :class_name => "Contact", :foreign_key => "sender_id"
  belongs_to :status_enum, :class_name => "LeadStatusEnum", :foreign_key => "status_id"

  before_create :init

  validates_associated :airframe
  validates_associated :recipient
  validates_associated :sender
  validates_associated :spec

  def init
    generate_url_codes()
    require_user_activation()
    self.status = "Sent"
  end

  def require_user_activation
    if !self.sender.user || self.sender.user.activated != true
      self.errors.add(:sender, "Please check account verification email")
      false
    end
  end

  def send
    XSpecMailer.sendRetail(self, self.recipient).deliver
  end

  # Sent, Bounced, Opened, Downloaded
  def status
    status_enum.status
  end
  def status=(code)
    status_enum = LeadStatusEnum.find_or_create_by_status(code)
  end  

  private

  # creates unique code for use as spec url
  def generate_url_codes

    self.spec_url_code = create_code
    while (Lead.where(:spec_url_code => self.spec_url_code).count > 0)
        self.spec_url_code = create_code
    end

    self.photos_url_code = create_code
    while (Lead.where(:photos_url_code => self.photos_url_code).count > 0)
        self.photos_url_code = create_code
    end    

  end

  def create_code
    BCrypt::Engine.generate_salt.gsub(/[^a-zA-Z0-9]+/, '').last(7)
  end

end
