namespace :js do

    desc "Prints out the first airframe"
    task :firstAf => :environment do

        puts Airframe.all.first

    end

end

namespace :db do
    desc "Destroys all objects in all tables in a SQLite DB"
    task :sqlclear => :environment do
        ActiveRecord::Base.establish_connection
        ActiveRecord::Base.connection.tables.each do |table|
          # MySQL
          # ActiveRecord::Base.connection.execute("TRUNCATE #{table}")

          # SQLite
          ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
        end
    end
end
