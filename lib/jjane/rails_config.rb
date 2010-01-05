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

I18n.load_path << Dir[File.join(File.dirname(__FILE__), '..', '..', 'locales', '*.{rb,yml}')]

ActionController::Base.append_view_path File.join(File.dirname(__FILE__), 'views')
