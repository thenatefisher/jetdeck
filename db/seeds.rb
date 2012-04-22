# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Clear current data
Location.delete_all
Address.delete_all
Contact.delete_all
User.delete_all
Airport.delete_all
Airframe.delete_all
Equipment.delete_all
Manufacturer.delete_all

# manufacturers
# models
# baseline_airframes
open("#{Rails.root}/db/aircraft_data.csv") do |infile|

  @max = 50
  infile.read.each_line do |row|

    if (@max == 0)
      break
    else
      @max-=1
    end

    aircraft = row.chomp.split(",")
    # MAKE MODEL SERIAL REG YEAR
    @model
    @make

      if (!aircraft[0] ||
          !aircraft[1] ||
          !aircraft[2] ||
          !aircraft[3] ||
          !aircraft[4] ||
          !aircraft[5])
          next
      end

    # Manufacturer
      # validate data
      if (aircraft[1].length == 0 || !(/^[\d]+(\.[\d]+){0,1}$/ === aircraft[0]))
          next
      end

      if (aircraft[1].length > 0 &&
          !Manufacturer.exists?(:name => aircraft[1]))
          @make = Manufacturer.create(:name => aircraft[1])
      end

    # Model
      # validate data
      if (aircraft[2].length > 0 &&
          !Equipment.exists?(
            :name => aircraft[2],
            "manufacturer_id" => @make))

          @model = Equipment.create(
            :name => aircraft[2],
            :make => @make,
            :etype => "airframe"
          )

      end

    # Baseline
      # validate data
      if (aircraft[3].length > 0 &&
          aircraft[4].length > 0 &&
          aircraft[5].length > 0)

        if (
          !Airframe.exists?(
          "model_id" => @model.id,
          :serial => aircraft[3],
          :baseline => true
          ))

            a = Airframe.create(
              :id => aircraft[0],
              :year => aircraft[5],
              :serial => aircraft[3],
              :registration => aircraft[4],
              "model_id" => @model.id,
              :baseline => true
            )

            puts "#" + @max.to_s +
            " ::\t id:" + a.id.to_s +
            "  year:" + a.year.to_s +
            "  make:" + @make.name +
            "  model:" + @model.name +
            "  msn:" + a.serial +
            "  reg:" + a.registration

        end

      end

  end

end

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

LocIdMax = Location.maximum(:id)
LocIdMin = Location.minimum(:id)
LocIdRange = LocIdMax - LocIdMin

fnames = [
"Tom",
"Bill",
"Richard",
"Jerome",
"Martin",
"Steve",
"Phil",
"Alex",
"Susan",
"Margarie",
"Ellen",
"Katie",
"Wynona",
"Mike"]

lnames = [
"Williams",
"Davies",
"Foster",
"Fisher",
"Smith",
"Lawrence",
"Wellers",
"Thompson",
"Loy",
"Fernandez",
"Scott",
"Jeffries"]

companies = [
"Avnet, Inc",
"Republic Services Group",
"IGN Global",
"AT&T Corp",
"Pinnacle West Capital Corporation ",
"First Solar",
"Insight Enterprises",
"Bashas' Supermarkets",
"Universal Technical Institute",
"Fennemore Craig ",
"Ballard Spahr",
"JDA Software Group",
"Leslie's Swimming Pool Supplies",
"Hensley & Co.",
"Desert Schools Federal Credit Union",
"TRRW LLC",
"Go Daddy ",
"Bastion Enterprises"]

titles = [
"Engineer Sr",
"Chief of Medicine",
"Chief Pilot",
"Owner",
"CEO",
"Chief Operating Office",
"Assitant to the VP of Engineering", "Director", "Director of Marketing"]

(0..50).each do |i|

  fname = fnames[rand(fnames.length)]
  lname = lnames[rand(lnames.length)]
  company = companies[rand(companies.length)]
  email = fname.downcase + "." + lname.downcase + "\@" + company.rstrip.lstrip.downcase.split(" ").first + ".com".to_s
  title = titles[rand(titles.length)]

  contact = Contact.create(
    :first => fname,
    :last => lname,
    :source => "",
    :email => email,
    :company => company,
    :title => title,
    :description => ""
  )

  Address.create(
    :location => Location.find(rand(LocIdRange).floor+LocIdMin),
    :contact => contact,
    :line1 => (rand(99999)+1000).to_s + " Main St",
    :description => "Home"
  )

  Address.create(
    :location => Location.find(rand(LocIdRange).floor+LocIdMin),
    :contact => contact,
    :line1 => (rand(99999)+1000).to_s + " Airport Rd",
    :description => "Office"
  )

  if (rand(3) > 1 || User.all.length == 0)
    user = User.create(:contact => contact)
  else
    UIdMax = User.maximum(:id)
    UIdMin = User.minimum(:id)
    UIdRange = UIdMax - UIdMin
    contact.user = User.find(rand(UIdRange).floor+UIdMin)
    contact.save
  end

end

# airports
Airport.create(
  :location => Location.where(:city=>"Phoenix").first,
  :icao => "KPHX",
  :name => "Phoenix Sky Harbor Intl")
Airport.create(
  :location => Location.where(:city=>"Los Angeles").first,
  :icao => "KLAX",
  :name => "Los Angeles International Airport")
Airport.create(
  :location => Location.where(:city=>"Denver").first,
  :icao => "KDEN",
  :name => "Denver Intl Airport")
Airport.create(
  :location => Location.where(:city=>"Atlanta").first,
  :icao => "KATL",
  :name => "Atlanta Hartsfield-Jackson Intl")
Airport.create(
  :location => Location.where(:city=>"Seattle").first,
  :icao => "KBFI",
  :name => "Seattle Boeing Field")
Airport.create(
  :location => Location.where(:city=>"Seattle").first,
  :icao => "KSEA",
  :name => "Seattle International Airport")
Airport.create(
  :location => Location.where(:city=>"Dallas").first,
  :icao => "KDAL",
  :name => "George Bush International Airport")
Airport.create(
  :location => Location.where(:city=>"Phoenix").first,
  :icao => "KDVR",
  :name => "Phoenix Deer Valley Airport")
Airport.create(
  :location => Location.where(:city=>"New York").first,
  :icao => "KEWR",
  :name => "Newark International Airport")

# airframes
# airframe_contacts
# specs
# spec_views
# spec_permissions
