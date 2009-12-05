require 'jjane/helpers'
require 'jjane/action_controller_extensions'

# adding JJane's controllers, helpers, models and...
%w{ controllers helpers models }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end
# ...and views
ActionController::Base.append_view_path File.join(File.dirname(__FILE__), 'app', 'views')

# including helpers
ActionView::Base.send :include, JJane::Helpers

# adding needed gems
Rails.configuration.gem 'authlogic'
Rails.configuration.gem 'mislav-will_paginate',
                        :version => '~> 2.3.11',
                        :lib => 'will_paginate',
                        :source => 'http://gems.github.com'
Rails.configuration.gem "robinsp-sortable_element_for_nested_set",
                        :lib    => "sortable_element_for_nested_set",
                        :source => "http://gems.github.com"
