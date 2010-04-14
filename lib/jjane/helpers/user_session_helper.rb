class JJane
  module Helpers
    # Methods of this helper can be used in views and controllers
    module User_SessionHelper

      #--
      #TODO переместить куда-то эти два метода,например в layout_helper
      #TODO что бы сохраняло back_url при повторном неправильном вводе логина-пароля
      #++
      def login_form options = {}, &proc
	back_url = request.url unless controller_name == 'login'
	form_for UserSession.new, options.merge(:url => login_path(:back_url => back_url)), &proc
      end

      def logout_link name, options = {}
	back_url = request.url unless controller_name == 'login'
	link_to name, logout_path(:back_url => back_url), options.merge(:method => :post)
      end

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
	  roles.empty? ? true : roles.include?(current_user.group.name)
	else
	  false
	end
      end
    end
  end
end
