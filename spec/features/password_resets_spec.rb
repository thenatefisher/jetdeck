require 'spec_helper'

describe "password reset page" do
  
    it "loads with 'Reset Password' on page", :js => true do
   
        visit "/password_resets"    
        
	      page.should have_content("Reset Password")

	      page.driver.render('password_reset_page.png', :full => true)
        
    end
    
    it "sends email to user with reset link" do
    
        # email addy
        email = "test@test" + Time.now.sec.to_s + ".com"
        
        # Create temp contact
        contact = Contact.create(
                        :first => "FIRSTNAME",
                        :last => "LASTNAME",
                        :email => email,
                        :company => "COMPANY",
                        :phone => "(404) 334-1124"
                    )
        
        # Create temp user
        user = User.create(
                        :contact => contact, 
                        :password_confirmation => "secret", 
                        :password => "secret"
                    )
          
        visit "/password_resets"
        
        page.should have_content("Reset Password")
        
        fill_in "email", :with => contact.email
        
        click_button "Reset"
        
        ActionMailer::Base.deliveries.last.should have_content(contact.email)
    
    end
    
end
        
