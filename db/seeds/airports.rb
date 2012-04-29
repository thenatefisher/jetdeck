puts "Creating Airport Data"

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

puts "Finished Creating Airport Data"
