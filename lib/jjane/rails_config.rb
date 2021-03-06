JJane.boot_log "adding gems dependencies"
Rails.configuration.gem 'authlogic'
Rails.configuration.gem 'will_paginate',
			:version => '2.3.11',
			:source => 'http://gemcutter.org'
Rails.configuration.gem 'kete-tiny_mce',
			:lib => 'tiny_mce',
			:source => 'http://gems.github.com'
Rails.configuration.gem 'paperclip',
			:version => '2.3.1.1',
			:source => 'http://gemcutter.org'
Rails.configuration.gem 'awesome_nested_set',
			:version => '1.4.3'

JJane.boot_log "appending load paths"
I18n.load_path << Dir[File.join(File.dirname(__FILE__), '..', '..', 'locales', '*.{rb,yml}')]
ActionController::Base.append_view_path File.join(File.dirname(__FILE__), 'views')

#awesome_nested_set gem loading fix
require 'awesome_nested_set'
ActiveRecord::Base.class_eval {include CollectiveIdea::Acts::NestedSet}
if defined?(ActionView)
  require 'awesome_nested_set/helper'
  ActionView::Base.class_eval {include CollectiveIdea::Acts::NestedSet::Helper}
end

JJane.boot_log "adding controllers models and helpers"
Rails.configuration.after_initialize do
  require "jjane/models"
  require "jjane/helpers"
  require "jjane/controllers"
end
