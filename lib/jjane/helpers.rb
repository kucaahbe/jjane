require 'jjane/helpers/navigation.rb'
require 'jjane/helpers/admin_panel.rb'
require 'jjane/helpers/user_session.rb'
require 'jjane/helpers/engine_main.rb'
require 'jjane/helpers/layout.rb'

module JJane
  # This module extends ActionView::Base with own methods for using in layout
  module Helpers
    include Layout
    include EngineMain
    include Navigation
    include AdminPanel
    include User_Session
  end
end

JJane::Helpers.included_modules.each do |mmodule|
  ActionView::Base.send :include, mmodule
  #ActionController::Base.send(:helper,JJane::Helpers)
  #TODO выкупить шо оно такое
end

