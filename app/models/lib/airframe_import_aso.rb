require "uri" 
require "open-uri"
require "nokogiri"  
require_relative "header_spoofer"

module AirframeImport

    def import_aso_images(airframe, link=nil)

        return nil if airframe.blank? || link.blank?

        include HeaderSpoofer
        content = open(link,
            "User-Agent" => HeaderSpoofer::header,
            "Referer" => "https://www.google.com/webhp?sourceid=chrome-instant&ion=1&ie=UTF-8").read rescue nil

        content.scan(/Graphic_Id":([\d]*),.*?File_Path":"~(.*?)"/).each_with_index do |image, index|
            img_id = image[0] rescue index
            thumb = AirframeImage.new(:image => open(URI::encode("http://www.aso.com/"+image[1]) ) )
            thumb.image_file_name = "#{img_id}.jpg"
            thumb.thumbnail = true if index == 0
            thumb.save
            airframe.accessories << thumb
        end        

    end

    def import_aso(user_id=nil, link=nil)

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

        # airframe
        airframe = Airframe.new()

        doc.css(".adSpecView-section-header").each do |header|
            case header.content
                when "Airframe & Power Systems Information"
                    page_details[:EngineSpecs] = header.next.inner_html rescue nil                
                when "Avionics"
                    page_details[:Avionics] = header.next.inner_html rescue nil
                when "Additional Equipment"
                    page_details[:AdditionalEquipment] = header.next.inner_html rescue nil
                when "Additional Equipment & Options"
                    page_details[:AdditionalEquipment] = header.next.inner_html rescue nil                
                when "Maintenance Condition"
                    page_details[:InspectionStatus] = header.next.inner_html rescue nil
                when "Maintenance & Weight"
                    page_details[:InspectionStatus] = header.next.inner_html rescue nil
                when "Modifications/Conversions"
                    page_details[:Modifications] = header.next.inner_html rescue nil
                when "Interior"
                    page_details[:Interior] = header.next.inner_html rescue nil  
                when "Exterior"
                    page_details[:Exterior] = header.next.inner_html rescue nil  
                when "Features"
                    page_details[:AdditionalEquipment] = header.next.inner_html rescue nil  
            end
        end

        # general parameters
        mms                                 = doc.css(".adSpecView-header-Descr div")[0].content rescue nil

        page_details[:Manufacturer]         = mms.match(/[\d]*?\s(.*?)\s/)[1] rescue nil
        page_details[:Model]                = mms[page_details[:Manufacturer].length+5..-1]
        page_details[:Year]                 = mms.match(/([\d]{4})/)[0] rescue nil

        page_details[:RegistrationNumber]   = doc.css(".adSpecView-header-RegSerialPrice")[0]
            .css("span")[0].content.gsub("Reg #", "") rescue nil

        page_details[:SerialNumber]         = doc.css(".adSpecView-header-RegSerialPrice")[0]
            .css("span")[1].content.gsub("Serial #", "") rescue nil

        page_details[:Price]                = doc.css(".adSpecView-header-RegSerialPrice")[1]
            .css("span")[0].content.gsub("Price:", "") rescue nil

        page_details[:Currency]             = doc.css(".adSpecView-header-RegSerialPrice")[1]
            .css("span")[1].content rescue nil       

        page_details[:TotalTime]            = doc.css(".adSpecView-header-RegSerialPrice")[2]
            .css("span")[0].content.gsub("TTAF", "") rescue nil

        page_details[:Location]             = doc.css(".adSpecView-header-RegSerialPrice")[2]
            .css("span")[1].content.gsub("Location:", "") rescue nil

        # for each parameter, remove all escapes and strip it
        page_details.each do |key, val|
            if val.present?
                page_details[key] = val.gsub(/[\r\n\t]/, "").strip 
            end
        end

        # find digits for numeric data
        page_details[:TotalTime].gsub!(/[^\d]/, "") if page_details[:TotalTime]
        page_details[:Price].gsub!(/[^\d]/, "") if page_details[:Price]

        # airframe parameters
        airframe.import_url     = link
        airframe.created_by     = user_id
        airframe.serial         = page_details[:SerialNumber]
        airframe.registration   = page_details[:RegistrationNumber]
        airframe.make           = page_details[:Manufacturer]
        airframe.model_name     = page_details[:Model]
        airframe.year           = page_details[:Year]
        airframe.asking_price   = page_details[:Price]

        # store images
        self.import_aso_images(airframe, link)

        airframe.save

        return airframe

    end

end