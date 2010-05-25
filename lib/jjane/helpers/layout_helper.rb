class JJane
  module Helpers
    module LayoutHelper

      # Shows notices in layout
      def notice
	partial 'engine/notice' if flash
      end

      # defualt engine head(css's javascripts and other tags)
      def engine_head
	partial 'engine/head'
      end

      def partial(view, params = nil)
	render :partial => view, :locals => params
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
