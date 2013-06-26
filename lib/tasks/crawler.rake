namespace :crawler do

  task :pull do

    url = "http://www.controller.com/listingsdetail/aircraft-for-sale/BEECHCRAFT-KING-AIR-F90/1981-BEECHCRAFT-KING-AIR-F90/1258449.htm"

    require 'nokogiri'
    require 'open-uri'

    doc = Nokogiri::HTML(open(url))

    doc.css('.detailstablecell').each do |link|
      puts link.content
    end

  end

end
