require 'uri' 
require 'open-uri'
require 'nokogiri'  
require_relative 'header_spoofer'

module AirframeImport

    def import_amp(user_id=nil, link=nil)

        link = "http://www.aso.com/listings/spec/ViewAd.aspx?id=145611&fAdvId=11381"

        # url is required
        return nil if user_id.blank? || link.blank?

        # fwd declare page hash
        page_details = Hash.new

        # spoof headers
        include HeaderSpoofer
        content = open(link,
            "User-Agent" => HeaderSpoofer::header,
            "Referer" => "https://www.google.com/webhp?sourceid=chrome-instant&ion=1&ie=UTF-8").read rescue nil

        # get page content        
        doc = Nokogiri::HTML(content)

        content.scan(/File_Path":"~(.*?)"/).each {|a| puts a}
        
        airframe = Airframe.new()

    end

end