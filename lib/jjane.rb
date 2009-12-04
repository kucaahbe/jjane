require 'jjane/helpers'
require 'jjane/action_controller_extensions'

%w{ controllers helpers models }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end
ActionController::Base.append_view_path File.join(File.dirname(__FILE__), 'app/views')

ActionView::Base.send :include, JJane::Helpers::CoreHelper

# install nessesary files
unless File.exists?(File.join(RAILS_ROOT,'public/jjane'))
  puts '=> installing JJane public files...'
  dest = File.join RAILS_ROOT, 'public', 'jjane'
  FileUtils.mkdir dest

  %w[ images javascripts stylesheets ].each do |dir|
    source = File.join File.dirname(__FILE__), '..', 'public'
    FileUtils.cp_r File.join(source, dir), dest
  end
end
