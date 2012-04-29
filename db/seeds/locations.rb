puts "Creating Locations Data"

Location.create(:country => 'United States', :state => 'Arizona', :stateAbbreviation => 'AZ', :city => 'Phoenix')
Location.create(:country => 'United States', :state => 'New York', :stateAbbreviation => 'NY', :city => 'Teterboro')
Location.create(:country => 'United States', :state => 'New York', :stateAbbreviation => 'NY', :city => 'New York')
Location.create(:country => 'United States', :state => 'Georgia', :stateAbbreviation => 'GA', :city => 'Lawrenceville')
Location.create(:country => 'United States', :state => 'Georgia', :stateAbbreviation => 'GA', :city => 'Atlanta')
Location.create(:country => 'United States', :state => 'Georgia', :stateAbbreviation => 'GA', :city => 'Kennesaw')
Location.create(:country => 'United States', :state => 'Arizona', :stateAbbreviation => 'AZ', :city => 'Scottsdale')
Location.create(:country => 'United States', :state => 'Arizona', :stateAbbreviation => 'AZ', :city => 'Tuscon')
Location.create(:country => 'United States', :state => 'California', :stateAbbreviation => 'CA', :city => 'San Diego')
Location.create(:country => 'United States', :state => 'California', :stateAbbreviation => 'CA', :city => 'Los Angeles')
Location.create(:country => 'United States', :state => 'Washington', :stateAbbreviation => 'WA', :city => 'Seattle')
Location.create(:country => 'United States', :state => 'Colorado', :stateAbbreviation => 'CO', :city => 'Denver')
Location.create(:country => 'United States', :state => 'Texas', :stateAbbreviation => 'TX', :city => 'Austin')
Location.create(:country => 'United States', :state => 'Texas', :stateAbbreviation => 'TX', :city => 'Dallas')

puts "Finished Creating Locations Data"
