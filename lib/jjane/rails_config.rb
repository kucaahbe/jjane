Rails.configuration.gem 'authlogic'
Rails.configuration.gem 'mislav-will_paginate',
                        :version => '~> 2.3.11',
                        :lib => 'will_paginate',
                        :source => 'http://gems.github.com'
Rails.configuration.gem "robinsp-sortable_element_for_nested_set",
                        :lib    => "sortable_element_for_nested_set",
                        :source => "http://gems.github.com"
Rails.configuration.gem 'kete-tiny_mce',
                        :lib => 'tiny_mce',
			:source => 'http://gems.github.com'

#--
# adding JJane's controllers, helpers, models and views
#++
app_path = File.dirname(__FILE__)

%w{ controllers helpers models }.each do |dir|
  path = File.join(app_path, dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end
ActionController::Base.append_view_path File.join(app_path, 'views')
