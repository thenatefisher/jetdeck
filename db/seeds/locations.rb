puts "Creating Locations Data"

Location.create(:country => 'United States', :state => 'Arizona', :state_abbreviation => 'AZ', :city => 'Phoenix')
Location.create(:country => 'United States', :state => 'New York', :state_abbreviation => 'NY', :city => 'Teterboro')
Location.create(:country => 'United States', :state => 'New York', :state_abbreviation => 'NY', :city => 'New York')
Location.create(:country => 'United States', :state => 'Georgia', :state_abbreviation => 'GA', :city => 'Lawrenceville')
Location.create(:country => 'United States', :state => 'Georgia', :state_abbreviation => 'GA', :city => 'Atlanta')
Location.create(:country => 'United States', :state => 'Georgia', :state_abbreviation => 'GA', :city => 'Kennesaw')
Location.create(:country => 'United States', :state => 'Arizona', :state_abbreviation => 'AZ', :city => 'Scottsdale')
Location.create(:country => 'United States', :state => 'Arizona', :state_abbreviation => 'AZ', :city => 'Tuscon')
Location.create(:country => 'United States', :state => 'California', :state_abbreviation => 'CA', :city => 'San Diego')
Location.create(:country => 'United States', :state => 'California', :state_abbreviation => 'CA', :city => 'Los Angeles')
Location.create(:country => 'United States', :state => 'Washington', :state_abbreviation => 'WA', :city => 'Seattle')
Location.create(:country => 'United States', :state => 'Colorado', :state_abbreviation => 'CO', :city => 'Denver')
Location.create(:country => 'United States', :state => 'Texas', :state_abbreviation => 'TX', :city => 'Austin')
Location.create(:country => 'United States', :state => 'Texas', :state_abbreviation => 'TX', :city => 'Dallas')

puts "Finished Creating Locations Data"
