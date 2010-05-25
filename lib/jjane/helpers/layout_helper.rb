class JJane
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
      # or 
      #   snippet :name_of_snippet
      # options:
      # * :compile - if true content of snippet will be compiled like ERB template
      def snippet name,options={}
	name = name.to_s
	options = { :compile => false }.merge(options)

	content = if Snippet.exists?(:name => name)
		    Snippet.find_by_name(name).content
		  else
		    Snippet.create!(:name => name).content
		  end
	content = render(:inline => content) if options[:compile]
	return content
      end

    end
  end
end
