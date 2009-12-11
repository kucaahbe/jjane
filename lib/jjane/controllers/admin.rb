module JJane
  module Controllers
    class Admin < ApplicationController

      before_filter :check_access, :except => [:welcome, :login, :logout, :show]

      def restart_passenger
	log `whoami`
        `touch tmp/restart.txt`
	if $?.exitstatus==0 then
	  flash[:notice]="Web server succsessfully restarted"
	else
	  flash[:error]="File #{RAILS_ROOT}/tmp/restart.txt must be writable by web server\'s user"
	end
	redirect_to welcome_path
      end
    end
  end
end
