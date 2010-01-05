require 'jjane/helpers/navigation.rb'
require 'jjane/helpers/admin_panel.rb'
require 'jjane/helpers/user_session.rb'
require 'jjane/helpers/engine_main.rb'
require 'jjane/helpers/layout.rb'
require 'jjane/helpers/pages_helper'

module JJane
  # This module adds helper methods for using in your layout
  module Helpers
    include Layout
    include EngineMain
    include Navigation
    include AdminPanel
    include User_Session
    include PagesHelper
  end
end

ActionController::Base.send(:helper,JJane::Helpers)
