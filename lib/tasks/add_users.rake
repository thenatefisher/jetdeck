namespace :users do

    task :add => :environment do

      c1 = Contact.create(
        :first => "Steve",
        :last => "Muller",
        :email => "stevemuller@alliedjet.com",
        :company => "Allied Jet",
        :phone => "(404) 386-5344",
        :title => "Vice President")

      u1 = User.create(
        :contact => c1, 
        :password => "sm6654", 
        :password_confirmation => "sm6654")    
      
      c2 = Contact.create(
        :first => "Tom",
        :last => "Kerstine",
        :email => "tk@tkaero.com",
        :company => "TK Aero",
        :phone => "(405) 495-3064",
        :title => "President")

      u2 = User.create(
        :contact => c2, 
        :password => "tk7456", 
        :password_confirmation => "tk7456")    
      
      c3 = Contact.create(
        :first => "Jerry",
        :last => "Hampton",
        :email => "jfhampton@aircraftlocators.net",
        :company => "Airfraft Locators",
        :phone => "(614) 855-5185",
        :title => "President")

      u3 = User.create(
        :contact => c3, 
        :password => "jh2984", 
        :password_confirmation => "jh2984")    
        
      c4 = Contact.create(
        :first => "Jerry",
        :last => "Shroer",
        :email => "jerry@eastwestaircraft.com",
        :company => "EastWest Aircraft Sales",
        :phone => "(239) 643-3466",
        :title => "Aircraft Sales Agent")

      u4 = User.create(
        :contact => c4, 
        :password => "js7845", 
        :password_confirmation => "js7845")    
        
      c5 = Contact.create(
        :first => "Mike",
        :last => "Swartz",
        :email => "Mike@PollardAircraft.com",
        :company => "Pollard Aircraft Sales",
        :phone => "817-800-9165",
        :title => "Aircraft Sales Agent")

      u5 = User.create(
        :contact => c5, 
        :password => "", 
        :password_confirmation => "")    
        
      c6 = Contact.create(
        :first => "Mark",
        :last => "Schlosberg",
        :email => "markschlosberg@earthlink.net",
        :company => "Schlosberg Enterprises",
        :phone => "(404) 518-5800",
        :title => "President")

      u6 = User.create(
        :contact => c6, 
        :password => "ms5234", 
        :password_confirmation => "ms5234")    
        
      c7 = Contact.create(
        :first => "Alok",
        :last => "Marwaha",
        :email => "alokgt@gmail.com",
        :company => "Marwaha Jet Services",
        :phone => "(832) 654-6735",
        :title => "President")

      u7 = User.create(
        :contact => c7, 
        :password => "am0192", 
        :password_confirmation => "am0192")    
        
      c8 = Contact.create(
        :first => "Bryan",
        :last => "Comstock",
        :email => "bc@jeteffect.com",
        :company => "JETEFFECT",
        :phone => "(912) 3303-8797",
        :title => "Aircraft Sales Agent")

      u8 = User.create(
        :contact => c8, 
        :password => "bc8293", 
        :password_confirmation => "bc8293")                                                  
            
    end
    
end
