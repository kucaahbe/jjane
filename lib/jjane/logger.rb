class JJane
  # Logger class consists helper methods for debugging
  module Logger
    # if you want to log something
    def log(something,msg=nil)#:doc:
      if msg
	logger.info "### #{msg.to_s} ###"
      else
	logger.info "#############################"
      end
      if something.class==Array
	logger.info "DEBUG::[#{something.class}]"
	something.each_with_index do |s,i|
	  logger.info "       [#{i}][#{s.class}]"+s.inspect
	end
      else
	logger.info "DEBUG::[#{something.class}]> "+something.inspect
      end
    end
  end
end

ActionController::Base.class_eval { 
  include JJane::Logger
  JJane::Logger.instance_methods.each { |method| private method; helper_method method }
}
ActiveRecord::Base.send :include, JJane::Logger
