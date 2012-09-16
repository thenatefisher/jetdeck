require 'spec_helper'

describe 'airframe' do

  airframe_path = ''
  credentials   = {}
  airframe = Airframe.new()
  
  it 'creation window appears and can create a new airframe', :js => true do

	  credentials = login

	  find('.new-spec').click
	  
	  screenshot('new_airframe_modal')

	  page.should have_selector('input#airframe_year')	
   	
	  fill_in 'year', :with => '2010'
	  
	  page.execute_script("
	  
	    $('#airframe_headline').select2('val', {
	        id: 'CUSTOM AIRFRAME', 
	        text: 'CUSTOM AIRFRAME'
	        })
	        
	    $('.select2-results li:first').click()
	    
	  ")	
	  
	  fill_in 'serial', :with => 'XX123'
	
	  screenshot('new_airframe_modal_filled')
	  
	  click_on 'Create Spec'
	
	  page.should have_content('XX123')

	  screenshot('new_airframe')
	
   	Airframe.where(:serial => 'XX123').count.should eq(1)

	  airframe = Airframe.where(:serial => 'XX123').first
	  
	  airframe_path = "/airframes/#{airframe.id}"

  end

  xit 'shows up in index', :js => true do
  
    login(credentials)
    
    screenshot('airframe_index')
    
    page.should have_content("2010 CUSTOM AIRFRAME")
      
  end
  
  it 'avionics can be added, edited and removed', :js => true do
  
  end  
  
  it 'equipment can be added, edited and removed', :js => true do
  
  end    

  it 'engines can be added, edited and removed', :js => true do
  
  end  
  
  
  # phantom js keeps crashing, cant test this yet
  xit 'images can be added, edited and removed', :js => true do
    
    login(credentials)
    
    visit airframe_path
    
    click_link 'manage_images_link'
    
    test_img = screenshot('airframe_images_list')
    
    #el = page.find('#airframe-image-input')
    
    #el.set(test_img)
    
    #attach_file('airframe-image-input', test_img)
    
    screenshot('add_test_image')
  
  end    
  
  it 'general details can be be updated', :js => true do

	  login(credentials)
	    
	  visit airframe_path
	  
	  screenshot('pre_edit_airframe')

	  fill_in 'registration', :with => '@@N123QD'
	  fill_in 'asking_price', :with => '1000000'
	  fill_in 'tt', :with => '4000'
	  fill_in 'tc', :with => '4000'
	  fill_in 'model_name', :with => 'NEW MODEL NAME'
	  fill_in 'description', :with => 'DESCRIPTION OF AIRFRAME'

    click_on 'save-changes'

	  screenshot('edit_airframe')

    Airframe.where(:registration => '@@N123QD').count.should eq(1)
    
    if airframe = Airframe.where(:registration => '@@N123QD').first
      airframe.asking_price.should eq(1000000)
      airframe.tt.should eq(4000)
      airframe.tc.should eq(4000)
      airframe.model_name.should eq('NEW MODEL NAME')
      airframe.description.should eq('DESCRIPTION OF AIRFRAME')
    end
    
  end

end
