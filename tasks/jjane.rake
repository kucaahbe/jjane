namespace :jjane do
  desc 'setup JJane'
  task :install do
    plugin_path               = File.join File.dirname(__FILE__), '..'
    app_public_path           = File.join RAILS_ROOT, 'public', 'jjane'
    plugin_public_path        = File.join File.dirname(__FILE__), '..', 'public'

    puts '=> installing JJane public files...'
    FileUtils.mkdir_p app_public_path
    %w[ images javascripts stylesheets ].each do |dir|
      FileUtils.cp_r File.join(plugin_public_path, dir), app_public_path
    end

    puts '=> creating symlinks for additional plugins..'
    Dir.foreach File.join(plugin_path,'plugins') do |plugin_dir|
      unless (plugin_dir=='.' or plugin_dir=='..')
	FileUtils.ln_s File.join(plugin_path, 'plugins', plugin_dir),
	  File.join(RAILS_ROOT, 'vendor', 'plugins'),
	  :force => true
      end
    end
  end
end
