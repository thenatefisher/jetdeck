class Contact < ActiveRecord::Base

  has_many :ownerships, :dependent => :destroy
  
  has_many :actions, :as => :actionable, :dependent => :destroy
  
  has_many :notes, :as => :notable, :dependent => :destroy
  
  has_many :files_sent,
      :class_name => "Lead",
      :foreign_key => "sender_id"

  has_many :files_received,
      :class_name => "Lead",
      :foreign_key => "recipient_id",
      :dependent => :destroy

  belongs_to :owner,
      :class_name => 'User',
      :foreign_key => 'owner_id'

  has_one :user,
      :class_name => 'User',
      :foreign_key => 'contact_id'
  
  attr_accessible :phone, :sticky_id,
        :first, :last, :source, :email, 
        :email_confirmation, :company, :details_attributes,
        :title, :description, :website, :emailFrom, :fullName

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

  validates_uniqueness_of :email, :scope => :owner_id,
                          :message => "Another contact already exists with this address"

  validates_format_of :email, 
                      :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
                      :message => "Email address is invalid" 

  validates_format_of :website, 
                      :with => URI::regexp(%w(http https)), 
                      :allow_blank => true, :allow_nil => true,
                      :message => "Invalid Website URL"
                      
  before_validation do
    self.email.gsub!(" ", "") if self.email
  end       
  
  def search_url
    "/contacts/#{id}"
  end
  
  def search_desc
    self.company
  end
  
  def search_label
    "<i class=\"icon-user\"></i> #{self.fullName}"
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
  
  def to_s
  
    sender_field = "#{self.email}"    
    
    if self.first.present?
    
      sender_field = "#{self.first.capitalize}" 
      
      if self.last.present?
      
        sender_field = "#{self.first.capitalize} #{self.last.capitalize}" 
      
      end
    
    end
    
    return sender_field
    
  end  
    
  def fullName
  
    fullName = ""    
    
    if self.first.present?
    
      fullName = self.first.capitalize
      
      if self.last.present?
      
        fullName = "#{self.first.capitalize} #{self.last.capitalize}" 
      
      end
    
    end
    
    return fullName
    
  end           
  
end
