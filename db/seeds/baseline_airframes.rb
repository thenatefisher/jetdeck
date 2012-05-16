puts "Creating Baseline Airframe Data"

# manufacturers, models, baseline_airframes
open("#{Rails.root}/db/seeds/data/aircraft_data.csv") do |infile|

  @max = 50
  infile.read.each_line do |row|

    if (@max == 0)
      break
    else
      @max-=1
    end

    aircraft = row.chomp.split(",")
    # MAKE MODEL SERIAL REG YEAR
    @model
    @make

      if (!aircraft[0] ||
          !aircraft[1] ||
          !aircraft[2] ||
          !aircraft[3] ||
          !aircraft[4] ||
          !aircraft[5])
          next
      end

    # Manufacturer
      # validate data
      if (aircraft[1].length == 0 || !(/^[\d]+(\.[\d]+){0,1}$/ === aircraft[0]))
          next
      end

      if (aircraft[1].length > 0 &&
          !Manufacturer.exists?(:name => aircraft[1]))
          @make = Manufacturer.create(:name => aircraft[1])
      end

    # Model
      # validate data
      if (aircraft[2].length > 0 &&
          !Equipment.exists?(
            :name => aircraft[2],
            "manufacturer_id" => @make))

          @model = Equipment.create(
            :name => aircraft[2],
            :make => @make,
            :etype => "airframes"
          )

      end

    # Baseline
      # validate data
      if (aircraft[3].length > 0 &&
          aircraft[4].length > 0 &&
          aircraft[5].length > 0)

        if (
          !Airframe.exists?(
          "model_id" => @model.id,
          :serial => aircraft[3],
          :baseline => true
          ))

            a = Airframe.new(
              :id => aircraft[0],
              :year => aircraft[5],
              :serial => aircraft[3],
              :registration => aircraft[4],
              "model_id" => @model.id,
              :baseline => true
            )

            for i in 1..2
                baselineEngine = Engine.first(:offset => rand(Engine.count).to_i)
                engine = baselineEngine.dup
                engine.baseline = false
                engine.baseline_id = baselineEngine.id
                engine.label = "Engine " + a.engines.length.to_s
                a.engines << engine
            end

            a.save

        end

      end

  end

end

puts "Finished Creating Baseline Airframe Data"
