class Lead < ActiveRecord::Base

  belongs_to :spec, :foreign_key => :spec_id, :class_name => "Accessory"
  belongs_to :airframe
  belongs_to :recipient, :class_name => "Contact", :foreign_key => "recipient_id"
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :status_enum, :class_name => "LeadStatusEnum", :foreign_key => "status_id"

  before_create :init

  validates_associated :airframe
  validates_presence_of :airframe
  validates_associated :recipient
  validates_presence_of :recipient
  validates_associated :sender
  validates_presence_of :sender
  validates_associated :spec
  validates_presence_of :spec, :message => "is required"

  def init
    generate_url_codes()
    require_user_activation()
  end

  def require_user_activation
    if !self.sender || self.sender.activated != true
      self.errors.add(:sender, "Please check account verification email")
      false
    end
  end

  def send_spec
    #XSpecMailer.sendRetail(self, self.recipient).deliver
  end

  # Sent, Bounced, Opened, Downloaded
  def status
    if self.status_enum.blank?
      self.status_enum = LeadStatusEnum.find_or_create_by_status("Unkown")
      self.status_date = Time.now()
      self.save
    end
    self.status_enum.status
  end
  def status=(code)
    self.status_enum = LeadStatusEnum.find_or_create_by_status(code)
    self.status_date = Time.now()
    self.save
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
