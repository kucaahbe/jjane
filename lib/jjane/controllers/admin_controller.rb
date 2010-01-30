class AdminController < ApplicationController#:nodoc:
  before_filter :check_access, :except => [:welcome, :login, :logout]
end
