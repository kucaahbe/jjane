require 'jjane/view_helpers/navigation.rb'
require 'jjane/view_helpers/admin_panel.rb'
require 'jjane/view_helpers/user_session.rb'
require 'jjane/view_helpers/core.rb'

module JJane
  # This module extends ActionView::Base with own methods for using in layout
  # TODO include Core
  module ViewHelpers
    include JJane::ViewHelpers::Core
    include JJane::ViewHelpers::Navigation
    include JJane::ViewHelpers::AdminPanel
    include JJane::ViewHelpers::UserSession
  end
end

ActionView::Base.send :include, JJane::ViewHelpers
