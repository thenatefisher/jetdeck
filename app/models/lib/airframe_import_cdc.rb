require "uri" 
require "open-uri"
require "nokogiri"  
require_relative "header_spoofer"

module AirframeImport

    def import_cdc_images(airframe, link=nil)
        return nil if airframe.blank? || link.blank?
        # add images
        listing_id = link.match(/([\d]+).htm[l]?/)[1] rescue nil
        if listing_id.present?
            mobile_link = "http://m.controller.com/Picture/Index?listingId=#{listing_id}"
            mobile_content = fetch_cdc(mobile_link)
            mobile_doc = Nokogiri::HTML(mobile_content)
            images_list = mobile_doc.css(".cImgList img")
            images_list.each_with_index do |img, index|
                img_id = img.attr("src").match(/id=([\d]*)/)[1] rescue index
                thumb = AirframeImage.new(:image => open(img.attr("src")))
                thumb.image_file_name = "#{img_id}.jpg"
                thumb.thumbnail = true if index == 0
                thumb.created_by = airframe.created_by
                thumb.save
                airframe.images << thumb
            end
        end
    end

    def import_cdc(user_id=nil, link=nil)

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

        # grab the details block at top of page, possible values include: 
        # Year, Manufacturer, Model, Price, Location, Condition, SerialNumber, 
        # RegistrationNumber, TotalTime, NumberOfSeats, Overhaul, FlightRules
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

        # convert to only digits
        page_details[:TotalTime].gsub!(/[^\d]/, "") if page_details[:TotalTime]
        page_details[:Price].gsub!(/[^\d]/, "") if page_details[:Price]

        # get general and detailed info
        page_details[:GeneralInformation] = doc.css("#ctl00_tdContent table:nth-child(4) tr:last-child td table:first-child tr:last-child td").last.content rescue nil
        page_details[:DetailedDescription] = doc.css("#ctl00_tdContent > table:nth-child(4) > tbody > tr:last-child > td > table").last rescue nil

        # detail sections
        details = doc.xpath("//table/tr/td/font/b/text()[contains(.,'Detailed Description')]")
            .first.parent.parent.parent.parent.next.inner_html rescue nil

        page_details[:DetailedDescription] ||= details.match(
            /detailstablecell\">(.*?)<font color=\"#910029\"><b>[\w\s]+:/m)[1] rescue nil
        page_details[:Airframe] = details.match(
            /Airframe:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:EngineSpecs] = details.match(
            /Engine Specs:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:Avionics] = details.match(
            /Avionics\/Radios:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:Props] = details.match(
            /Prop\(s\):<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:Modifications] = details.match(
            /Modifications\/Conversions:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:AdditionalEquipment] = details.match(
            /Additional Equipment:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:InspectionStatus] = details.match(
            /Inspection Status:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:Exterior] = details.match(
            /Exterior:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:Interior] = details.match(
            /Interior:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1] rescue nil
        page_details[:YearPainted] = details.match(
            /Year Painted:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1].gsub!(/[^\d]/, "") rescue nil
        page_details[:YearInterior] = details.match(
            /Year Interior:<\/b><\/font><br>(.*?)((?:<\/td)|(?:<hr))/m)[1].gsub!(/[^\d]/, "") rescue nil

        airframe = Airframe.new()

        # store airframe details        
        airframe.import_url     = link
        airframe.created_by     = user_id
        airframe.serial         = page_details[:SerialNumber]
        airframe.registration   = page_details[:RegistrationNumber]
        airframe.make           = page_details[:Manufacturer]
        airframe.model_name     = page_details[:Model]
        airframe.year           = page_details[:Year]
        airframe.asking_price   = page_details[:Price]
        airframe.description    = page_details[:DetailedDescription]
        airframe.save

        self.import_cdc_images(airframe, link)

        return airframe.save

    end

    def decode_string(str) 
        return URI.unescape str
    end

    def fetch_cdc(url)

        include HeaderSpoofer
        header = HeaderSpoofer::header
        referer = "https://www.google.com/webhp?sourceid=chrome-instant&ion=1&ie=UTF-8"
        doc = `curl --user-agent "#{header}" --referer "#{referer}" "#{url}"`
        
        begin 
            table   = doc.match(/table = \"(.*)\"/)[1]
            prefix  = doc.match(/document\.forms\[0\]\.elements\[1\]\.value=\"([^:]*)/)[1]
            c       = doc.match(/c = (.*)$/)[1]
            slt     = doc.match(/slt = \"(.*)\"/)[1]
            s1      = doc.match(/s1 = '(.*)'/)[1]
            s2      = doc.match(/s2 = '(.*)'/)[1]
            n       = 4
            clg     = ""
        rescue
            return doc
        end

        start = s1.ord
        cend = s2.ord
        arr = Array.new()
        m = ((cend - start) + 1)**n

        for i in 0..(n-1)
            arr[i] = s1
        end

      
        for i in 0..(m - 2)
            
            (n-1).downto(0) do |j|
                t = arr[j].ord
                t = t+1
                arr[j] = t.chr("UTF-8")
                if (arr[j].ord <= cend)
                    break
                else
                    arr[j] = s1
                end
            end
            
            chlg = arr.join("")
            str = chlg + slt
            crc = -1
            
            for k in 0..(str.length - 1)
                index = crc ^ str[k].ord if str[k]
                index ||= -1
                si = ((index & 0x000000FF) * 9)
                t_hex_s = "0x" + table[si..(si+8)]
                thex = (t_hex_s).hex
                crc = (crc >> 8) ^ thex
                crc = (crc > 2**31) ? crc - 2**32 : crc
                crc = (crc < -2147483648) ? sprintf("%b", ~((crc.abs)))[3..-1].to_i(2)+1 : crc
            end
            
            crc = crc^(-1)
            crc = crc.abs
            if (crc == c.to_i)
                break
            end
            
        end

        # parameters for document request
        tS40436f_75 = decode_string(prefix + ":" + chlg.to_s + ":" + slt.to_s + ":" + crc.to_s)
        tS40436f_id = 3
        tS40436f_md = 1
        tS40436f_rf = "http://www.controller.com/"
        tS40436f_ct = 0
        tS40436f_pd = 0
        
        content = `curl -i -F "tS40436f_id=3&tS40436f_md=1&tS40436f_rf=0&tS40436f_ct=0&tS40436f_pd=0&tS40436f_75=#{tS40436f_75}"  --user-agent "#{header}" "#{url}"`
        
    end

end