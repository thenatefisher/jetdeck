namespace :update_db do

    task :faa => :environment do
      
      open("#{Rails.root}/db/seeds/data/FAA_MASTER.csv") do |infile|
        infile.read.each_line do |row|

          aircraft = row.split(",")

          registration      = aircraft[0].strip
          serial            = aircraft[1].strip
          af_mfg_code       = aircraft[2].strip      
          eng_mfg_code      = aircraft[3].strip
          year              = aircraft[4].strip.to_i
          eng_type          = aircraft[19].strip.to_i
          af_type           = aircraft[18].strip.to_i
          cert_type         = aircraft[17].strip.to_i
          
          eng_count         = 0
          af_model          = nil
          af_make           = nil
          eng_make          = nil
          eng_model         = nil
          
          if (cert_type == 1) &&
            (year > 1980) && 
            (eng_type > 1) && 
            (eng_type < 6) && 
            (af_type > 3) && 
            (af_type < 7)
          
                acft_ref = open("#{Rails.root}/db/seeds/data/FAA_ACFTREF.csv")
                  .grep(/#{af_mfg_code}/i).first
                  
                if acft_ref 
                  acft_ref = acft_ref.split(",")
                  ref_code = acft_ref[0].strip
                  if (ref_code == af_mfg_code)
                    af_make  = acft_ref[1].strip
                    af_model = acft_ref[2].strip
                    eng_count  = acft_ref[7].to_i
                  end
                end
                
                eng_ref = open("#{Rails.root}/db/seeds/data/FAA_ENGINE.csv")
                  .grep(/#{eng_mfg_code}/i).first
                  
                if eng_ref 
                  eng_ref = eng_ref.split(",")
                  ref_code = eng_ref[0].strip
                  if (ref_code == eng_mfg_code)
                    eng_make = eng_ref[1].strip
                    eng_model = eng_ref[2].strip
                  end
                end
                          
                a = Airframe.where(
                  :serial => serial, 
                  :year => year, 
                  :model_name => af_model, 
                  :make => af_make, 
                  :baseline => true).first || 
                Airframe.create(
                  :registration => "N#{registration}", 
                  :serial => serial, 
                  :year => year, 
                  :model_name => af_model, 
                  :make => af_make, 
                  :baseline => true)
                
                e = Engine.where(
                  :model_name => eng_model, 
                  :make => eng_make, 
                  :baseline => true).first || 
                Engine.create(
                  :model_name => eng_model, 
                  :make => eng_make, 
                  :baseline => true)
                
                if e && a.engines.empty?
                  for i in 1..eng_count
                    eng = e.dup
                    eng.baseline = false
                    a.engines << eng
                  end
                end
                
                a.save
                
                print "#{year} "
                print "(Eng Count: #{eng_count} )"
                print "#{af_make} "
                print "#{af_model} "
                print "N#{registration} "
                print "SN:#{serial}\n"
          
          end
          
        end
      end

    end

end
