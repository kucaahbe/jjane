module ActionController#:nodoc:
  class Base

    filter_parameter_logging :password, :content

    helper_method :log

    private
    
    include JJane::ViewHelpers::UserSession

    # if you want restrict access to some actions in controller just do:
    #   before_filter :check_access ,:only => [:action]
    def check_access#:doc:
      error_404 unless logged_in?('root') 
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
      render '/site/error_404', :status => 404, :layout => 'application'
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

    #--
    #       DEBUG METHODS
    #++
    # if you want to log something
    def log(something,msg='')#:doc:
      logger.info "###########################################################"
      if something.class==Array
	logger.info "DEBUG::[#{something.class}]"
	something.each_with_index do |s,i|
	  logger.info "       [#{i}][#{s.class}]"+s.inspect
	end
      else
	logger.info "DEBUG::[#{something.class}]> "+something.inspect
      end
      logger.info msg
    end
  end
end
