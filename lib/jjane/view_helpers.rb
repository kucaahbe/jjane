require 'jjane/view_helpers/navigation.rb'
require 'jjane/view_helpers/admin_panel.rb'
require 'jjane/view_helpers/user_session.rb'
require 'jjane/view_helpers/core.rb'

module JJane
  # This module extends ActionView::Base with own methods for using in layout
  module ViewHelpers
    include Core
    include Navigation
    include AdminPanel
    include UserSession
  end
end

ActionController::Base.send :helper, JJane::ViewHelpers
