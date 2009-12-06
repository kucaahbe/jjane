namespace :db do
  db_config = File.join('config','database.yml')
  db_dump = File.join('tmp','database_dump.yml')

  desc "Dumps contents of database to a YAML file(#{db_dump}) for the current RAILS_ENV"
  task :dump2yaml do
    require 'activerecord'
    params = YAML.load(File.open(db_config))
    ActiveRecord::Base.establish_connection(params[RAILS_ENV])

    sql  = 'SELECT * FROM %s'
    skip_tables = ['schema_info','schema_migrations']

    File.open(db_dump, 'w') do |file|
      db_hash = {}
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
	print table_name
	db_hash[table_name] = []
	ActiveRecord::Base.connection.select_all(sql % table_name).each_with_index do |obj,n|
	  db_hash[table_name][n]=obj; print '.'
	end
	puts
      end
      file.write db_hash.to_yaml
    end
  end

  desc "Loads database contents from YAML file(#{db_dump}) for the current RAILS_ENV"
  task :yaml2db => :environment do
    database = YAML.load(File.open(db_dump))

    database.each do |table, record|
      print 'Loading '+table
      table.classify.constantize.create(record)
      puts
    end
  end
end
