namespace :jjane do
  namespace :files do
    desc 'install JJane public files'
    task :install do

      dot = lambda { print '.' }

      plugin_path = File.join File.dirname(__FILE__), '..'

      puts '=> installing JJane public files'
      FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'jjane')
      FileUtils.mkdir_p File.join(RAILS_ROOT, 'public', 'jjane')
      %w[ images stylesheets javascripts ].each do |dir|
	FileUtils.cp_r File.join(plugin_path, 'public', dir), File.join(RAILS_ROOT, 'public', 'jjane')
	dot
      end

      puts '=> installing sample config files'
      Dir["#{plugin_path}/config/*"].each do |file|
	FileUtils.cp_r file, File.join(RAILS_ROOT, 'config')
	dot
      end
    end
  end

  namespace :db do
    desc 'Load JJane root user'
    task :loadroot => :environment do

      email = 'root@localhost.net'
      name = 'root'
      password = 'root'
      password_confirmation = password

      User.create!(
	:name                  => name,
	:password              => password,
	:password_confirmation => password_confirmation,
	:email                 => email,
	:group_id              => Group.find_by_name('roots').id
      )
      puts "Root user succesfully loaded."
    end

    desc 'Load JJane\'s startup data'
    task :init => :environment do
      unless Group.exists?
	puts 'Creating groups...'
	Group.create!(:name => 'roots')
      end

      unless User.exists?
	puts 'Creating root user...'
	Rake::Task['jjane:db:loadroot'].invoke 
      end

      unless Page.exists?
	puts 'Creating home page...'
	page = Page.create!(
	  :name                  => 'homepage',
	  :link                  => 'home',
	  :menu                  => 'Home Page',
	  :page_type             => 'static',
	  :user_id               =>  Group.find_by_name('roots').users.first.id,
	  :nav_main              =>  true
	)
      end
      puts "\nsetup finished."
    end
  end
end
