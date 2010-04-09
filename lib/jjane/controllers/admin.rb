class AdminController < ApplicationController#:nodoc:
  prepend_view_path 'app/views/nodes'
  before_filter :check_access, :except => [:welcome, :login, :logout]
end
