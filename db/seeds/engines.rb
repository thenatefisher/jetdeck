# engines

["PT6-114", "PT6A-28", "PT6A-135A", "PT6-34"].each do |m|

    for j in 0..10
        Engine.create(
            :serial => "PCE-"+(1000+rand(7000)).to_s,
            :ttsn => rand(10000),
            :tcsn => rand(10000),
            :year => 1990 + rand(20),
            :smoh => rand(5000),
            :tbo => 3600,
            :hsi => 1800,
            :shsi => rand(4000),
            :baseline => true,
            :modelName => m,
            :make => "Pratt and Whitney"
        )
    end
    
end


