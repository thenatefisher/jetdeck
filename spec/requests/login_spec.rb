require 'spec_helper'

describe 'login page' do

  it 'allows login with valid username and password', :js => true do
	
    login  

    screenshot('login')

    page.should have_content("FIRSTNAME LASTNAME")
    
  end
  
  it "shows 'forgot password' link with bogus login", :js => true do

    visit "/login"
    
    screenshot('pre_forgot_password')

    fill_in "email", :with => "bogus"

    fill_in "password", :with => "secret"

    click_button "Log In" 

    screenshot('forgot_password')
    
    page.should have_content("Forgot")   
    
  end
  
end
