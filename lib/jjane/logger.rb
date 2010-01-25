module JJane
  # Logger class consists helper methods for debugging
  module Logger
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

ActionController::Base.class_eval { 
  include JJane::Logger
  JJane::Logger.instance_methods.each { |method| private method; helper_method method }
}
ActiveRecord::Base.send :include, JJane::Logger
