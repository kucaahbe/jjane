module JJane
  module Helpers
    module LayoutHelper

      # Показывает напоминания типа: "вы успешно авторизировались"
      def notice
	partial 'engine/notice' if flash
      end

      # alias for stylesheet_link_tag
      def stylesheet(*args)
	stylesheet_link_tag(*args.map(&:to_s))
      end

      # alias for javascript_include_tag
      def javascript(*args)
	args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
	javascript_include_tag(*args)
      end

      # defualt engine head(css's javascripts and other tags)
      def engine_head
	partial 'engine/head'
      end

      def hide_me_if(something)
	yield unless something
      end

      # put thin in place where you want admin panel appear
      def admin_panel
	partial 'engine/administrator_panel' if logged_in?('roots')
      end

      # writes snippet content to page
      #   snippet('name_of_snippet')
      # options:
      # * :compile - if true content of snippet will be compiled like ERB template
      def snippet(name='',args={})
	defaults = { :compile => false }
	args = defaults.merge(args)
	content = Snippet.find_by_name(name).content
	content = render(:inline => content) if args[:compile]
	return content
      rescue
	%(<p style='color:red;'>snippet not found</p>)
      end

    end
  end
end
