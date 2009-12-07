# adding JJane's controllers, helpers, models and views
app_path = File.join(File.dirname(__FILE__), '..', 'app')

%w{ controllers helpers models }.each do |dir|
  path = File.join(app_path, dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end
ActionController::Base.append_view_path File.join(app_path, 'views')
