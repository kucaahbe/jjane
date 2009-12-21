module JJane
  module Helpers
    module User_Session

      def current_user_session
	return @current_user_session if defined?(@current_user_session)
	@current_user_session = UserSession.find
      end

      def current_user
	return @current_user if defined?(@current_user)
	@current_user = current_user_session && current_user_session.record
      end

      def logged_in?(*roles)
	if current_user_session
	  roles.empty? ? true : roles.include?(current_user.role)
	else
	  false
	end
      end
    end
  end
end
