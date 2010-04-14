require 'jjane/helpers/navigation_helper.rb'
require 'jjane/helpers/admin_panel_helper.rb'
require 'jjane/helpers/user_session_helper.rb'
require 'jjane/helpers/engine_main_helper.rb'
require 'jjane/helpers/layout_helper.rb'
require 'jjane/helpers/pages_helper'
require 'jjane/helpers/misc_helper'

class JJane
  # This module adds helper methods for using in your layout
  module Helpers
    #TODO
    #def self.included(base)
    # и тут включаем все модули
    #end
    include LayoutHelper
    include EngineMainHelper
    include NavigationHelper
    include AdminPanelHelper
    include User_SessionHelper
    include PagesHelper
  end
end

ActionController::Base.send(:helper,JJane::Helpers)
