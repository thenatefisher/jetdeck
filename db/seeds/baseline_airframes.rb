puts "Creating Baseline Airframe Data"

# manufacturers, models, baseline_airframes
open("#{Rails.root}/db/seeds/data/aircraft_data.csv") do |infile|

  
    infile.read.each_line do |row|

        1000.times {next}

        aircraft = row.chomp.split(",")
        # MAKE MODEL SERIAL REG YEAR

        if (!aircraft[0] ||
          !aircraft[1] ||
          !aircraft[2] ||
          !aircraft[3] ||
          !aircraft[4] ||
          !aircraft[5])
          next
        end

        # validate data
        if (aircraft[1].length == 0 || !(/^[\d]+(\.[\d]+){0,1}$/ === aircraft[0]))
            next
        end

        a = Airframe.new(
            :id => aircraft[0],
            :year => aircraft[5],
            :serial => aircraft[3],
            :registration => aircraft[4],
            :modelName => aircraft[2],
            :make => aircraft[1],
            :baseline => true
        )

        for i in 1..2
            baselineEngine = Engine.first(:offset => rand(Engine.count).to_i)
            engine = baselineEngine.dup
            engine.baseline = false
            engine.baseline_id = baselineEngine.id
            a.engines << engine
        end

        a.save
        
    end

end

puts "Finished Creating Baseline Airframe Data"
