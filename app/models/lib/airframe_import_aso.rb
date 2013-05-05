module AirframeImport

    def AirframeImport::import_aso(link=nil)

        require 'nokogiri'        

        # url is required
        return if link.blank?

        # capture page
        page_details = Hash.new
        doc = Nokogiri::HTML(open(link))

        # grab the details block at top of page
        # possible values include: Year, Manufacturer, Model, Price, Location, Condition, SerialNumber, RegistrationNumber, TotalTime, NumberOfSeats
        doc.css("#tblSpecs tr").each do |tr|
            if tr.css("td").count == 2
                begin
                    param = tr.css("td")[0].content.gsub(/[^a-zA-Z0-9]/, "")
                    value = tr.css("td")[1].content.gsub(/[^a-zA-Z0-9\- ]/, "")
                    page_details[param.to_sym] = value if !param.blank?
                rescue
                    next
                end
            end
        end

        # fix total time to be only digits
        page_details[:TotalTime].gsub!(/[^\d]/, "") if page_details[:TotalTime]

        # get general and detailed info
        page_details[:GeneralInformation] = doc.css("#ctl00_tdContent table:nth-child(4) tr:last-child td table:first-child tr:last-child td").last.content rescue nil
        page_details[:DetailedDescription] = doc.css("#ctl00_tdContent > table:nth-child(4) > tbody > tr:last-child > td > table").last rescue nil

        # detail sections
        details = doc.xpath("//table/tr/td/font/b/text()[contains(.,'Detailed Description')]").first.parent.parent.parent.parent.next.inner_html rescue nil
        page_details[:DetailedDescription] = details.match(/detailstablecell\">(.*?)<font color=\"#910029\"><b>[\w\s]+:/m)[1] rescue nil
        page_details[:Airframe] = details.match(/<hr[^>]*>.*Airframe:<\/b><\/font><br>(.*?)<hr/m)[1] rescue nil
        page_details[:EngineSpecs] = details.match(/<hr[^>]*>.*Engine Specs:<\/b><\/font><br>(.*?)<hr/m)[1] rescue nil
        page_details[:Avionics] = details.match(/<hr[^>]*>.*Avionics\/Radios:<\/b><\/font><br>(.*?)<hr/m)[1] rescue nil
        page_details[:Props] = details.match(/<hr[^>]*>.*Props:<\/b><\/font><br>(.*?)<hr/m)[1] rescue nil
        page_details[:AdditionalEquipment] = details.match(/<hr[^>]*>.*Additional Equipment:<\/b><\/font><br>(.*?)<hr/m)[1] rescue nil
        page_details[:InspectionStatus] = details.match(/<hr[^>]*>.*Inspection Status:<\/b><\/font><br>(.*?)<hr/m)[1] rescue nil
        page_details[:Exterior] = details.match(/<hr[^>]*>.*Exterior:<\/b><\/font><br>(.*?)<hr/m)[1] rescue nil
        page_details[:Interior] = details.match(/<hr[^>]*>.*Interior:<\/b><\/font><br>(.*?)<hr/m)[1] rescue nil

        # remove all escapes and strip it
        page_details.each do |key, val|
            page_details[key] = val.gsub(/[\r\n\t]/, "").strip if val.present?
        end

    end

end