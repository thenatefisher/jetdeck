class Xspec < ActiveRecord::Base

  has_many :views, :foreign_key => :spec_id, :class_name => "SpecView", :dependent => :destroy
  belongs_to :airframe
  belongs_to :recipient, :class_name => "Contact", :foreign_key => "recipient_id"
  belongs_to :sender, :class_name => "Contact", :foreign_key => "sender_id"

  before_save :unique_recipients_per_airframe

  before_create :init

  belongs_to :background, :class_name => "XspecBackground", :foreign_key => "background_id"

  validates_associated :airframe
  validates_associated :recipient
  validates_associated :sender

  attr_accessor :hits, :fire

  def init
    generate_url_code()
    require_user_activation()
  end

  def require_user_activation
    if !self.sender.user || self.sender.user.activated != true
      self.errors.add(:sender, "Please check account activation email")
      false
    end
  end

  def unique_recipients_per_airframe

    if self.id.nil?
      if Xspec.where("recipient_id = ? AND airframe_id = ?", self.recipient, self.airframe).length > 0
        self.errors.add(:recipient, "is already on the lead list")
        false
      end
    else
      if Xspec.where("recipient_id = ? AND airframe_id = ? AND id != ?", self.recipient, self.airframe, self.id).length > 0
        self.errors.add(:recipient, "is already on the lead list")
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

  def history
  
    if self.views.where("created_at > ?", 30.days.ago).count == 0
      return
    end
  
    window_start = self.views.where("created_at > ?", 30.days.ago).first.created_at
    window_end = window_start + 24.hours
    series_start = window_start
    result = []
  
    until Time.now() < window_start
    
      result.push(
        self.views.where("created_at < ? AND created_at > ?", window_end, window_start).length
      )
    
      window_start += 24.hours
      window_end = window_start + 24.hours
      
    end
  
    return {:data => result, :start => series_start.strftime("%s") }
    
  end
  
  def top_average
    
    min = "00"
    sec = "00"
    padding = ""  

    if self.views.count > 0
    
      avg = self.views.sum(:time_on_page).to_i / self.views.count
      min = (avg / 60).floor
      sec = avg - 60 * min
      padding = (sec < 10) ? "0" : ""  

    end
    
    return "#{min}:#{padding}#{sec}"

  end  

  def fire

    recent_views = views.where("created_at > ?", Time.now - 24.hours).count

    false # return false if not on fire

    true if recent_views > 3

  end

  private

  # creates unique code for use as spec url
  def generate_url_code

    self.url_code = create_code
    while (Xspec.where(:url_code => self.url_code).count > 0)
        self.url_code = create_code
    end

    # show the message by default
    self.show_message = true

  end

  def create_code
    BCrypt::Engine.generate_salt.gsub(/[^a-zA-Z0-9]+/, '').last(7)
  end

end
