require 'spec_helper'

describe 'airframe' do

  airframe_path = ''
  credentials   = {}
  airframe = Airframe.new()
  
  it 'creation window appears and can create a new airframe', :js => true do

	  credentials = login

	  find('#new-spec').click
	  
	  screenshot('new_airframe_modal')

	  page.should have_selector('input#airframe_year')	
   	
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
	
	  screenshot('new_airframe_modal_filled')
	  
	  click_on 'Create Spec'
	
	  page.should have_content('XX123')

	  screenshot('new_airframe')
	
   	Airframe.where(:serial => 'XX123').count.should eq(1)

	  airframe = Airframe.where(:serial => 'XX123').first
	  
	  airframe_path = "/airframes/#{airframe.id}"

  end

  it 'shows up in index', :js => true do
  
    login(credentials)
    
    screenshot('airframe_index')
    
    page.should have_content("2010 CUSTOM AIRFRAME")
    
    page.should have_content("XX123")
      
  end
  
  it 'avionics can be added, edited and removed', :js => true do
  
    e =  Equipment.create(:etype => "avionics", :name => "avionics ITEM XXYY")
    
    airframe.equipment << e
    
    login(credentials)
    
    visit airframe_path
    
    find("a[href='#pane_avionics']").click
    
    page.should have_content("avionics ITEM XXYY")
    	  
    screenshot('find_avionics_item_xxyy')
    
    page.should have_selector("#avionics-name-input") 
    
    fill_in 'avionics-name-input', :with => "New Avionics Item"
    
    find('.add-equipment').click
   
	  screenshot('after_add_avionics')
	  
    click_on 'save-changes'

	  screenshot('add_avionics_saved')
	  
	  airframe.equipment.where(:name => "New Avionics Item").count.should eq(1)
	    
  end  
  
  it 'equipment can be added, edited and removed', :js => true do
    
    e =  Equipment.create(:etype => "equipment", :name => "EQUIPMENT ITEM XXYY")
    
    airframe.equipment << e
    
    login(credentials)
    
    visit airframe_path
    
    find("a[href='#pane_equipment']").click
    
    page.should have_content("EQUIPMENT ITEM XXYY")
    	  
    screenshot('find_equipment_item_xxyy')
    
    #page.should have_selector("#new-equipment-input") 
    
    #fill_in 'new-equipment-input', :with => "New Equipment Item"
    
    #find('.add_equipment').click
    
	  screenshot('after_add_equipment')
	  
    click_on 'save-changes'

	  screenshot('add_equipment_saved')    
      
  end    

  it 'engines can be added, edited and removed', :js => true do
  
    e =  Engine.create(:name => "Test Engine XXYY")
    
    airframe.engines << e
      
    login(credentials)
    
    visit airframe_path
    
    find("a[href='#pane_engines']").click
    
    page.should have_content("Test Engine XXYY")
    	  
    screenshot('pre_add_engine')
    
	  page.execute_script("
	  
      $('.select2-container a').click()
      $('.select2-search input').val('test')
      $('.select2-container a').click()
      $('.select2-search input').val('test')
      $('.select2-container a').click()
      $('.select2-search input').val('test')	    
	              
	  ")	
	  
	  find('.select2-results li:first').click
	  
	  find('.add_engine').click
	  
	  screenshot('add_engine')
	  
    click_on 'save-changes'

	  screenshot('add_engine_saved')	
	  
	  airframe.engines.count.should eq(1)  
	    
  end  
  
  it 'images can be added, edited and removed', :js => true do
    
    login(credentials)
    
    visit airframe_path
    
    find('.manage_images').click
    
    test_img = screenshot('airframe_images_list')
    
    el = page.find('#airframe-image-input')
    
    el.set(test_img)
    
    attach_file('airframe-image-input', test_img)
    
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
  
  it 'can be destroyed', :js => true do
  
	  login(credentials)
	    
	  visit airframe_path
	  
	  find("#delete-section").click
	  
	  screenshot('pre_delete_airframe')
	  
	  find("#delete-confirm").click
	  
	  visit "/"
	  
	  page.should_not have_content("2010 CUSTOM AIRFRAME") 
	  
	  screenshot('after_delete_airframe')
	  
  end

end
