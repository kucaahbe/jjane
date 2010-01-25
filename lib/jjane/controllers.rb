module JJane
  module ActionController#:nodoc:
    class Base#:nodoc:
      module Extensions

	def self.included(mod)
	  mod.filter_parameter_logging :password, :content
	end

	private

	include JJane::Helpers::User_SessionHelper

	# if you want restrict access to some actions in controller just do:
	#   before_filter :check_access ,:only => [:action]
	def check_access#:doc:
	  error_404 unless logged_in?('roots') 
	end

	# shows ERROR 404
	#   def show 
	#     @article = Article.find(params[:id])
	#     if @article
	#       render somewhere
	#     else
	#       error_404
	#     end
	#   end
	def error_404 #:doc:
	  flash[:notice] = "The requested URL #{request.request_uri} was not found on this server."; flash.discard
	  render '/pages/errors/404', :status => 404, :layout => :application
	rescue
	  render_optional_error_file(404)
	end

	#--
	#        DRY methods
	#++
	# notice User, :created => flash[:notice] = "User was successfully created"
	def notice(model,word)#:doc:
	  flash[:notice] = "#{model} was successfully #{word}."
	end

	def notice_error(model,word)#:doc:
	  flash[:error] = "#{model} was NOT #{word}."
	end

	#   render :partial => view, :locals => params
	def partial(view, params = {})#:doc:
	  render :partial => view, :locals => params
	end

      end
    end
  end
end

ActionController::Base.send :include, JJane::ActionController::Base::Extensions
