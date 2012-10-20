class Invite < ActiveRecord::Base

  belongs_to :sender, :class_name => "User", :foreign_key => "from_user_id"
  
  validates_presence_of :from_user_id  
  
  validates_presence_of :email
  
  validates_format_of :email, 
                      :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
                      :message => "Email address is invalid"  
  
  before_create :create_token

  def create_token 
  
    self.activated = false
    
    self.token = BCrypt::Engine.generate_salt.gsub(/[^a-zA-Z0-9]+/, '').last(7)
    
    while (Invite.where(:token => self.token).count > 0)
        self.token = BCrypt::Engine.generate_salt.gsub(/[^a-zA-Z0-9]+/, '').last(7)
    end
  
  end

end
