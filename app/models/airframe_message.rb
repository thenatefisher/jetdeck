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

    def init
        self.status_id ||= 0
        self.status_date ||= Time.now()
        self.photos_enabled ||= true
        self.spec_enabled ||= true
        generate_url_codes()
        require_user_activation()        
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

    def require_user_activation
        if !self.creator || self.creator.activated != true
          self.errors.add(:creator, "Please check account verification email")
          false
        end
    end


end
