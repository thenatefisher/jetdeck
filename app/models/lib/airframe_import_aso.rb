require 'uri' 
require 'open-uri'
require 'nokogiri'  
require_relative 'header_spoofer'

module AirframeImport

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

        airframe = Airframe.new()

        # for each parameter, remove all escapes and strip it
        page_details.each do |key, val|
            if val.present?
                page_details[key] = val.gsub(/[\r\n\t]/, "").strip 
                airframe.airframe_texts << AirframeText.create(:label => key, :body => val)
            end
        end

        # store airframe details        
        airframe.import_url     = link
        airframe.user_id        = user_id
        airframe.serial         = page_details[:SerialNumber]
        airframe.registration   = page_details[:RegistrationNumber]
        airframe.make           = page_details[:Manufacturer]
        airframe.model_name     = page_details[:Model]
        airframe.year           = page_details[:Year]
        airframe.asking_price   = page_details[:Price]
        airframe.description    = page_details[:DetailedDescription]
        airframe.tt             = page_details[:TotalTime]

        # add thumbnail if available
        listing_id = link.match(/([\d]+).htm[l]?/)[1] rescue nil
        if listing_id.present?
            mobile_link = "http://m.controller.com/Picture/Index?listingId=#{listing_id}"
            mobile_content = fetch_cdc(mobile_link)
            mobile_doc = Nokogiri::HTML(mobile_content)
            images_list = mobile_doc.css(".cImgList img")
            images_list.each_with_index do |img, index|
                thumb = Accessory.new(:image => open(img.attr("src")))
                img_id = img.attr("src").match(/id=([\d]*)/)[1] rescue index
                thumb.image_file_name = "#{img_id}.jpg"
                thumb.thumbnail = true if index == 0
                thumb.save
                airframe.accessories << thumb
            end
        end

        return airframe.save

    end

end