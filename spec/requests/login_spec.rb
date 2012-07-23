require 'spec_helper'

describe "login page page" do
  
  it "redirects to home page and displays the user's username after successful login" do
    
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
    
    # Login and verify user's name shows up
    visit login_path
    fill_in "email", :with => email
    fill_in "password", :with => "secret"
    click_button "Log In" 
    page.should have_content("FIRSTNAME LASTNAME")
    
  end
  
  it "shows 'forgot password' link with bogus login" do

    visit login_path
    fill_in "email", :with => "bogus"
    fill_in "password", :with => "secret"
    click_button "Log In" 
    page.should have_content("Forgot")   

  end
  
  
  
end
