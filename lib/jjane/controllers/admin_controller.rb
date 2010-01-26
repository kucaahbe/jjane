class AdminController < ApplicationController

  before_filter :check_access, :except => [:welcome, :login, :logout]

end
