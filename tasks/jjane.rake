namespace :jjane do
  desc 'install JJane'
  task :copy_files do

    dot = Proc.new { print '.' }

    plugin_path = File.join File.dirname(__FILE__), '..'

    puts '=> installing JJane public files'
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


  desc 'Add JJane root user for the current RAILS_ENV'
  task :addroot => :environment do
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
      :name                  => name,
      :password              => password,
      :password_confirmation => password_confirmation,
      :email                 => email,
      :group_id              => Group.find_by_name('roots').id
    )
    puts "\nUser succesfully added."
  end

  desc 'Load JJane defaults for the current RAILS_ENV'
  task :setup => :environment do
    unless Group.exists?
      puts 'Creating groups...'
      Group.create!(:name => 'roots')
    end
    
    unless User.exists?
      puts 'Creating root user...'
      Rake::Task['jjane:addroot'].invoke 
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
