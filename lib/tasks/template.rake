namespace :js do

    desc "Prints out the first airframe"
    task :firstAf => :environment do

        puts Airframe.all.first

    end

end


