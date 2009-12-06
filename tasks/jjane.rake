namespace :jjane do
  desc 'install JJane'
  task :install do
    plugin_path = File.join File.dirname(__FILE__), '..'

    puts '=> installing JJane public files...'
    FileUtils.mkdir_p File.join(RAILS_ROOT, 'public', 'jjane')
    %w[ images javascripts stylesheets ].each do |dir|
      FileUtils.cp_r File.join(plugin_path, 'public', dir),
	File.join(RAILS_ROOT, 'public', 'jjane')
    end

    puts '=> creating symlinks for plugins...'
    Dir["#{plugin_path}/plugins/**"].each do |plugin_dir|
	FileUtils.ln_s plugin_dir, File.join(RAILS_ROOT, 'vendor', 'plugins'),
	  :force => true
    end

    puts '=> copying config files...'
    Dir["#{plugin_path}/config/*"].each do |file|
      FileUtils.cp_r file, File.join(RAILS_ROOT, 'config')
    end
  end

  desc 'setup JJane for the current RAILS_ENV'
  task :setup => :environment do
    require 'highline/import'

    Rake::Task['db:migrate'].invoke

    print "Enter data for root user:\n"
    email = ask('E-mail adress:') do |q|
      q.validate = Authlogic::Regex.email
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
    #add page migration

    puts "\nsetup finished"

  end
end
