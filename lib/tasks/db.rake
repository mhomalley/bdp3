require 'import_from_mssql'

namespace :db do
  task :import => :environment do
    desc "Import all the data from the old MSSQL database. This transforms it into the new scheme."
    ImportFromMSSQL.run
  end
end

