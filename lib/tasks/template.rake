namespace :databases do

    task :faa => :environment do
      
      open("/home/nate/Desktop/MASTER.csv") do |infile|
        infile.read.each_line do |row|

          aircraft = row.split(",")

          registration = aircraft[0].strip
          serial = aircraft[1].strip
          af_mfg_code = aircraft[2].strip      
          eng_mfg_code = aircraft[3].strip
          year = aircraft[4].strip.to_i
          eng_type = aircraft[19].strip.to_i
          af_type = aircraft[18].strip.to_i
          
          if (year > 2005) && 
            (eng_type > 0) && 
            (eng_type < 6) && 
            (af_type > 3) && 
            (af_type < 7)
          
                acft_ref = open("/home/nate/Desktop/ACFTREF.txt").grep(/#{af_mfg_code}/i).first
                if acft_ref 
                  acft_ref = acft_ref.split(",")
                  ref_code = acft_ref[0]
                  if (ref_code == af_mfg_code)
                    af_make  = acft_ref[1]
                    af_model = acft_ref[2]
                    engines  = acft_ref[7]
                  end
                end
                
                ref = open("/home/nate/Desktop/ENGINE.txt").grep(/#{eng_mfg_code}/i).first
                if ref 
                  ref = ref.split(",")
                  ref_code = ref[0]
                  if (ref_code == eng_mfg_code)
                    eng_make = ref[1]
                    eng_model = ref[2]
                  end
                end
                          
                Airframe.create(:registration => "N#{registration}", :serial => serial, :year => year, :model_name => af_model, :make => af_make, :baseline => true)
                Engine.where(:model_name => eng_model, :make => eng_make, :baseline => true).first || Engine.create(:model_name => eng_model, :make => eng_make, :baseline => true)
                
                print "#{year} #{af_make} #{af_model} N#{registration} SN:#{serial}\n"
          
          end
          
        end
      end

    end

end
