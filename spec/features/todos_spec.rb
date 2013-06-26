
require 'spec_helper'

describe 'todos' do

  airframe_path = ''
  credentials   = {}
  airframe = Airframe.new()
  
  it 'can be added to airframe', :js => true do

	  credentials = login

	  find('#new-spec').click
   	
	  fill_in 'year', :with => '2010'
	  
	  page.execute_script("
	  
      $('.select2-container a').click()
      $('.select2-search input').val('CUSTOM AIRFRAME')
      $('.select2-container a').click()
      $('.select2-search input').val('CUSTOM AIRFRAME')
      $('.select2-container a').click()
      $('.select2-search input').val('CUSTOM AIRFRAME')	    
	              
	  ")	
	  
	  find('.select2-results li:first').click
	  	  
	  fill_in 'serial', :with => 'XX123'

	  click_on 'Create Spec'

	  airframe = Airframe.where(:serial => 'XX123').first
	  
	  airframe_path = "/airframes/#{airframe.id}"

    fill_in "new-action-textarea", :with => "New Action Item"
    
    find("#add-action").click
    
    screenshot("after_add_action_to_airframe")

  end


end
