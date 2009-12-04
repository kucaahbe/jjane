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
