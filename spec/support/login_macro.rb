module UserLogin
		
	def login(credentials = nil)

	    # email addy
	    email = "test@test_" + Time.now.strftime("%M%S") + ".com"
	    
	    # use supplied value if available
			if credentials && credentials[:email]
			  email = credentials[:email]
			end
			
	    # Create temp contact
	    contact = Contact.find_by_email(email) || 
	      Contact.create(
			    :first => "FIRSTNAME",
			    :last => "LASTNAME",
			    :email => email,
			    :company => "COMPANY",
			    :phone => "(404) 334-1124"
			)

	    # Create temp user
	    user = contact.user || 
	      User.create(
			    :contact => contact,
			    :password_confirmation => "secret",
			    :password => "secret"
			)

	    # Login and verify user's name shows up
	    visit "/login"
	    
      # uncomment for debugging the spec 
      # screenshot('prelogin')
      
	    fill_in "email", :with => email

	    fill_in "password", :with => "secret"

	    click_button "Log In"
	    
	    {:email => contact[:email], :password => user[:password]}
	    
	end

end
