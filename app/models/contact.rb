class Contact < ActiveRecord::Base

  has_many :specsSent,
      :class_name => "Xspec",
      :foreign_key => "sender_id"

  has_many :specsReceived,
      :class_name => "Xspec",
      :foreign_key => "recipient_id",
      :dependent => :destroy

  has_one :base,
      :class_name => 'Contact',
      :foreign_key => 'baseline_id',
      :readonly => true

  has_one :owner,
      :class_name => 'User',
      :foreign_key => 'owner_id'

  has_one :user,
      :class_name => 'User',
      :foreign_key => 'contact_id'
  
  attr_accessible :phone, 
        :first, :last, :source, :email, 
        :email_confirmation, :company, 
        :title, :description, :website, :emailFrom, :fullName

  has_many :credits, :as => :creditable

  validates_presence_of :email,
                        :message => "Email address is required"

  validates_presence_of :email_confirmation, 
                        :message => "Confirm email address", 
                        :if => :email_changed?, :on => :update,
                        :unless => Proc.new { |q| q.user.nil? }
  
  validates_confirmation_of :email, 
                            :message => "Email should match confirmation", 
                            :if => :email_changed?, :on => :update,
                            :unless => Proc.new { |q| q.user.nil? }

  # todo uniqueness is also specific to an owner
  #validates_uniqueness_of :email

  validates_format_of :email, 
                      :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
                      :message => "Email address is invalid" 

  validates_format_of :website, 
                      :with => URI::regexp(%w(http https)), 
                      :allow_blank => true, :allow_nil => true,
                      :message => "Invalid Website URL"
                      
  before_validation do
    self.email.sub!(" ", "")
  end       
  
  def emailField
  
    sender_field = "<#{self.email}>"    
    
    if self.first.present?
    
      sender_field = "#{self.first} <#{self.email}>" 
      
      if self.last.present?
      
        sender_field = "#{self.first} #{self.last} <#{self.email}>" 
      
      end
    
    end
    
    return sender_field
    
  end       
  
  def fullName
  
    fullName = ""    
    
    if self.first.present?
    
      fullName = self.first
      
      if self.last.present?
      
        fullName = "#{self.first} #{self.last}" 
      
      end
    
    end
    
    return fullName
    
  end           
  
end
