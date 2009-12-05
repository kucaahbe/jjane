# adding JJane's controllers, helpers, models and...
%w{ controllers helpers models }.each do |dir|
  path = File.join(File.dirname(__FILE__), '..', 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end
# ...and views
ActionController::Base.append_view_path File.join(File.dirname(__FILE__), 'app', 'views')
