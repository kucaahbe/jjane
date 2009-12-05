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


namespace :jjane do
  desc 'Install JJane for the current RAILS_ENV'
  task :installl => :environment do
    require 'highline/import'

    answer = agree('This will be destroy any data in database,are you agree?(yes/no):')
    raise "" unless answer

    ActiveRecord::Base.establish_connection(RAILS_ENV)
    ActiveRecord::Base.connection.tables.each { |table| ActiveRecord::Migration.drop_table table }
    Rake::Task['db:migrate'].invoke

    print "Enter data for root user:\n"
    email = ask('E-mail adress:') do |q|
      q.validate=/^\w+@\w+.\w{2,3}$/
      q.responses[:not_valid]='e-mail should look like e-mail address'
    end
    login = ask('Administrator login:') { |q| q.default='root' }
    name = ask('Administrator name:')
    password = ask('Password:') {|q| q.echo = false }
    password_confirmation = ask('Confirm password:') {|q| q.echo = false }

    User.create!(:name => name,
		 :login => login,
		 :password => password,
		 :password_confirmation => password_confirmation,
		 :email => email,
		 :role => 'root')

    puts "\nsetup finished"
  end
end

namespace :jjane do
  namespace :config do
    desc 'List of defined menus for the current RAILS_ENV'
    task :nav => :environment do
      Page.menus.each { |menu| puts menu }
    end

    namespace :nav do
      desc 'Adds menu for the current RAILS_ENV'
      task :add => :environment do
	require 'highline/import'
	name = ask('Name:') do |q|
	  q.validate=/^[a-z]{3,4}$/
	  q.responses[:not_valid]='must consist only latin characters and from 3 to 4 characters'
	end
	ActiveRecord::Migration.add_column :pages, "nav_#{name}", :boolean
      end

      desc 'Removes menu for the current RAILS_ENV'
      task :remove => :environment do
	require 'highline/import'
	name = choose do |menu|
	  menu.prompt = 'Choose menu for deletion'
	  Page.menus.each { |m| menu.choice(m) }
	end
	ActiveRecord::Migration.remove_column :pages, "nav_#{name}"
      end
    end
  end
end
