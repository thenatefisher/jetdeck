require "uri" 
require "open-uri"
require "nokogiri"  
require_relative "header_spoofer"

module AirframeImport

    def get_content(import_url)

        # url is required
        return nil if import_url.blank? 

        # spoof headers
        include HeaderSpoofer
        content = open(import_url,
            "User-Agent" => HeaderSpoofer::header,
            "Referer" => "https://www.google.com/webhp?sourceid=chrome-instant&ion=1&ie=UTF-8") rescue nil;

        return content

    end

    def import_aso_images(airframe, content)

        # skip in case airframe is now deleted
        return nil if airframe.blank? || airframe.destroyed?

        # crawl page for images
        content.scan(/Graphic_Id":([\d]*),.*?File_Path":"~(.*?)"/).each_with_index do |image, index|

            img_id = image[0] rescue index

            # dont re-add photos
            if AirframeImage.where(:image_file_name => "#{img_id}.jpg", :airframe_id => airframe.id).blank?

                # grab image from remote site and doll it up
                image = AirframeImage.new(:image => self.get_content(URI::encode("http://www.aso.com/"+image[1]) ) )
                image.image_file_name   = "#{img_id}.jpg"
                image.thumbnail         = true if index == 0
                image.created_by        = airframe.created_by

                # attach to airframe
                airframe.images << image 

            end

        end        

    end

    def import_aso_essentials(airframe, content)

        # skip in case airframe is now deleted
        return nil if airframe.blank? || airframe.destroyed?

        # create a hash to hold details
        page_details = Hash.new

        # parse the document
        doc = Nokogiri::HTML(content)

        # grab all the important stuff
        mms                                 = doc.css(".adSpecView-header-Descr div")[0].content rescue nil
        page_details[:Manufacturer]         = mms.match(/[\d]*?\s(.*?)\s/)[1] rescue nil
        page_details[:Model]                = mms[page_details[:Manufacturer].length+5..-1] rescue nil
        page_details[:Year]                 = mms.match(/([\d]{4})/)[0] rescue nil
        page_details[:RegistrationNumber]   = doc.css(".adSpecView-header-RegSerialPrice")[0]
            .css("span")[0].content.gsub("Reg #", "") rescue nil

        page_details[:SerialNumber]         = doc.css(".adSpecView-header-RegSerialPrice")[0]
            .css("span")[1].content.gsub("Serial #", "") rescue nil

        page_details[:Price]                = doc.css(".adSpecView-header-RegSerialPrice")[1]
            .css("span")[0].content.gsub("Price:", "") rescue nil
        page_details[:Price].gsub!(/[^\d]/, "") if page_details[:Price]

        # for each parameter, remove all escapes and strip it
        page_details.each do |key, val|
            if val.present?
                page_details[key] = val.gsub(/[\r\n\t]/, "").strip 
            end
        end

        # store off the details
        airframe.serial         = page_details[:SerialNumber]
        airframe.registration   = page_details[:RegistrationNumber]
        airframe.make           = page_details[:Manufacturer]
        airframe.model_name     = page_details[:Model]
        airframe.year           = page_details[:Year]
        airframe.asking_price   = page_details[:Price]
        
        # save
        airframe.save!

    end

    def import_aso_details(airframe, content)

        # fwd declare page hash
        page_details = Hash.new

        # get page content        
        doc = Nokogiri::HTML(content)

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

    end

    def import_aso(airframe)

        begin

            if airframe.present? && !airframe.destroyed?
                # get content
                content = self.get_content(airframe.import_url).read
                return nil if content.blank?

                airframe.save!
                self.delay(:priority => 0).import_aso_essentials(airframe, content) if airframe.new_import
                #self.delay(:priority => 2).import_aso_details(airframe, content) if airframe.new_import
                self.delay(:priority => 3).import_aso_images(airframe, content)
                
                return airframe
            end

        rescue => error

            if airframe.present? && !airframe.destroyed?
                airframe.model_name = "Import Failed" if airframe.new_import
                airframe.save! 

                
                NewRelic::Agent.notice_error("Airframe Import Error: #{error.message}", {
                    :url => airframe.import_url, 
                    :user_id => airframe.created_by
                })

            else
                NewRelic::Agent.notice_error("Airframe Import Error, Airframe record not available: #{error.message}")
            end

        end

    end

end