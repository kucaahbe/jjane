namespace :jjane do
  desc 'install JJane'
  task :copy_files do
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

    print "Enter data for root user:\n"
    email = ask('E-mail adress:') do |q|
      q.validate = Authlogic::Regex.email
      q.responses[:not_valid]='e-mail should look like e-mail address'
    end
    name = ask('Administrator name:')
    password = ask('Password:') {|q| q.echo = false }
    password_confirmation = ask('Confirm password:') {|q| q.echo = false }

    User.create!(
      :name => name,
      :password => password,
      :password_confirmation => password_confirmation,
      :email => email,
      :role => 'root'
    )
    Page.create!(
      :id => 1,
      :name => 'home',
      :title => 'home page',
      :link => 'home',
      :_type_ => 'static',
      :nav_main => true
      )

      puts "\nsetup finished"

  end
end
