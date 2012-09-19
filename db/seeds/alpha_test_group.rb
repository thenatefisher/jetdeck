  chaddevans = Contact.create(
    :first => "Chadd",
    :last => "Evans",
    :email => "chadd.evans@gmail.com",
    :company => "Creative Bulb",
    :title => "President")
  
  User.create(
    :contact => chaddevans, 
    :password => "creativebulb", 
    :password_confirmation => "creativebulb")
    
## == 

  jenevans = Contact.create(
    :first => "Jen",
    :last => "Evans",
    :email => "jen.f.evans@gmail.com",
    :company => "Creative Bulb",
    :title => "President")
  
  User.create(
    :contact => jenevans, 
    :password => "creativebulb", 
    :password_confirmation => "creativebulb")    

## == 
    
  davegeddes = Contact.create(
    :first => "Dave",
    :last => "Geddes",
    :email => "dave@sportronix.com",
    :company => "Sportronix",
    :title => "Founder")
  
  User.create(
    :contact => davegeddes, 
    :password => "sportronix", 
    :password_confirmation => "sportronix")

## == 
    
  alext = Contact.create(
    :first => "Alex",
    :last => "Teodorescu",
    :email => "ateodorescu721@gmail.com",
    :company => "Alex's Sky Whips",
    :title => "MFCEO")
  
  User.create(
    :contact => alext, 
    :password => "airwhips", 
    :password_confirmation => "airwhips")
    
# ==

  alexh = Contact.create(
    :first => "Alex",
    :last => "Hoffman",
    :email => "ajhoffman@gmail.com",
    :company => "Alex's Sky Whips",
    :title => "MFCEO")
  
  User.create(
    :contact => alexh, 
    :password => "airwhipsmofo", 
    :password_confirmation => "airwhipsmofo")
    
# ==

  ryanr = Contact.create(
    :first => "Ryan",
    :last => "Rodd",
    :email => "ryanrodd@gmail.com",
    :company => "United States of America, Inc",
    :title => "President")
  
  User.create(
    :contact => ryanr, 
    :password => "usabiatch", 
    :password_confirmation => "usabiatch")
    
# ==

  glennf = Contact.create(
    :first => "Glenn",
    :last => "Fisher",
    :email => "glenn.e.fisher@gmail.com",
    :company => "Glenn-Sells-Jets.com, Inc",
    :title => "President and CEO")
  
  User.create(
    :contact => glennf, 
    :password => "gsjbiatch", 
    :password_confirmation => "gsjbiatch")
    
# ==

  gloy = Contact.create(
    :first => "Geoffrey",
    :last => "Loy",
    :email => "gloy850@gmail.com",
    :company => "Geoff's Jets, Inc",
    :title => "President")
  
  User.create(
    :contact => gloy, 
    :password => "gjibiatch", 
    :password_confirmation => "gjibiatch")    


