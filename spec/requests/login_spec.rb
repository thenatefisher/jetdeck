require 'spec_helper'

describe 'login page' do

 it 'allows login with valid username and password', :js => true do
	
    login  

    page.driver.render(ScreenshotPath + '/login.png')

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
