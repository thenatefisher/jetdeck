class Contact < ActiveRecord::Base

  has_many :specsSent,
      :class_name => "Xspec",
      :foreign_key => "sender_id"

  has_many :specsReceived,
      :class_name => "Xspec",
      :foreign_key => "recipient_id"

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
        :title, :description

  has_many :credits, :as => :creditable

  validates_presence_of :email
  
  validates_presence_of :email_confirmation, 
                        :message => "Confirm email address", 
                        :if => :email_changed?, :on => :update
  
  validates_confirmation_of :email, 
                            :message => "should match confirmation", 
                            :if => :email_changed?, :on => :update
  
  # todo uniqueness is also specific to an owner
  #validates_uniqueness_of :email

  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i

end
