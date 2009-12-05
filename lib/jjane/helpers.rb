require 'jjane/helpers/nav_helper.rb'
require 'jjane/helpers/admin_panel_helper.rb'
require 'jjane/helpers/user_session_helper.rb'
require 'jjane/helpers/core_helper.rb'

module JJane
  module Helpers
    include JJane::Helpers::CoreHelper
    include JJane::Helpers::NavHelper
    include JJane::Helpers::AdminPanelHelper
    include JJane::Helpers::UserSessionHelper
  end
end
