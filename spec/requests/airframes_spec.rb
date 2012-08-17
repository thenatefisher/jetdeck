require 'spec_helper'

describe 'airframe' do

  airframe_path = ""

  it 'creation window', :js => true do

	login

	find(".new-spec").click

	page.should have_selector("input#airframe_year")	
 	
	fill_in "year", :with => "2010"
	page.execute_script("$('#airframe_headline').select2('val', {id: 'CUSTOM AIRFRAME', text: 'CUSTOM AIRFRAME'})")	
	fill_in "serial", :with => "XX123"
	
	click_on "Create Spec"
	
	page.should have_content("XX123")

	page.driver.render(ScreenshotPath + 'new_spec.png', :full => true)
	
 	Airframe.where(:serial => "XX123").count.should eq(1)

	airframe_path = current_path

  end

  it 'registration be updated', :js => true do

	login

	visit airframe_path

	fill_in "registration", :with => "N123JD"

	page.driver.render(ScreenshotPath + 'edit_spec.png', :full => true)

 	Airframe.where(:registration => "N123JD").count.should eq(1)

  end

end
