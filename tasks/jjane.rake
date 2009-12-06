namespace :jjane do
  desc 'setup JJane'
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
end
