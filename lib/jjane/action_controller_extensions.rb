class ActionController::Base

  filter_parameter_logging :password, :content

  helper_method :log

  private

  include JJane::Helpers::UserSessionHelper

  def check_access
    error_404 unless logged_in?('root') 
  end

  def error_404
    flash[:notice] = "The requested URL #{request.request_uri} was not found on this server."; flash.discard
    render '/site/error_404', :status => 404, :layout => 'application'
  rescue
    render_optional_error_file(404)
  end

  # ---------------------------
  #        DRY methods
  # ---------------------------
  def get_model_name
    self.class.to_s.gsub(/Controller/,'').singularize
  end

  def notice(word)
    flash[:notice] = "#{get_model_name} was successfully #{word}."
  end

  def partial(view, params = nil)
    render :partial => view, :locals => params
  end

  def find_model
    get_model_name.constantize.find(params[:id])
  end

  # ---------------------------
  #       DEBUG METHODS
  # ---------------------------
  def log(something,msg='')
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
