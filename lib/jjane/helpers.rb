require 'jjane/helpers/navigation_helper.rb'
require 'jjane/helpers/admin_panel_helper.rb'
require 'jjane/helpers/user_session_helper.rb'
require 'jjane/helpers/engine_main_helper.rb'
require 'jjane/helpers/layout_helper.rb'
require 'jjane/helpers/pages_helper'
require 'jjane/helpers/tabbar_helper'

module JJane
  # This module adds helper methods for using in your layout
  module Helpers
    include LayoutHelper
    include EngineMainHelper
    include NavigationHelper
    include AdminPanelHelper
    include User_SessionHelper
    include PagesHelper
  end
end

ActionController::Base.send(:helper,JJane::Helpers)
#ActionView::Base.class_eval {
#  include JJane::Helpers
#}
