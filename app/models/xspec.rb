class Xspec < ActiveRecord::Base
  has_many :views, :foreign_key => :spec_id, :class_name => "SpecView", :dependent => :destroy
  #has_many :spec_permissions, :dependent => :destroy
  belongs_to :airframe
  belongs_to :recipient, :class_name => "Contact", :foreign_key => "recipient"
  belongs_to :sender, :class_name => "Contact", :foreign_key => "sender"
  
  before_save :generate_url_code
  
  validates_presence_of :airframe
  validates_presence_of :recipient
  validates_presence_of :sender
  
  attr_accessor :hits
  
  def send_spec
    
    # mail spec link to recipient
  
  end
  
  def hits
    self.views.length
  end
    
  private
  
  # creates unique code for use as spec url
  def generate_url_code
    
    self.urlCode = create_code
    while (Xspec.where(:urlCode => self.urlCode).length > 0)
        self.urlCode = create_code
    end
      
  end
  
  def create_code
    BCrypt::Engine.generate_salt.gsub(/[\.]+/, '').last(7)
  end

  
end
