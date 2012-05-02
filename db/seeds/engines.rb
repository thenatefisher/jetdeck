# engines

pw = Manufacturer.create(:name => "Pratt and Whitney")
hon = Manufacturer.create(:name => "Honeywell")
rr = Manufacturer.create(:name => "Rolls Royce")
ge = Manufacturer.create(:name => "GE Engines")

["PT6-114", "PT6A-28", "PT6A-135A", "PT6-34"].each do |m|

    model = Equipment.create(
        :make => pw,
        :modelNumber => m,
        :etype => "engines"
    )

    for j in 0..10
        Engine.create(
            :serial => "PCE-"+(1000+rand(7000)).to_s,
            :totalTime => rand(10000),
            :totalCycles => rand(10000),
            :year => 1990 + rand(20),
            :smoh => rand(5000),
            :tbo => 3600,
            :hsi => 1800,
            :shsi => rand(4000),
            :m => model,
            :baseline => true
        )
    end
    
end


