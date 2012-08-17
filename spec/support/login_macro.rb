module UserLogin
		
	def login

	    # email addy
	    email = "test@test" + Time.now.sec.to_s + ".com"

	    # Create temp contact
	    contact = Contact.create(
			    :first => "FIRSTNAME",
			    :last => "LASTNAME",
			    :email => email,
			    :company => "COMPANY",
			    :phone => "(404) 334-1124"
			)

	    # Create temp user
	    user = User.create(
			    :contact => contact,
			    :password_confirmation => "secret",
			    :password => "secret"
			)

	    # Login and verify user's name shows up
	    visit login_path

	    fill_in "email", :with => email

	    fill_in "password", :with => "secret"

	    click_button "Log In"

	end

end
