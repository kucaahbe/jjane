module JJane
  module Helpers
    module Core

      # put this into your _title_ tag:
      #   <title><%= site_title %></title>
      def site_title
	@page.title if controller_name=='site'
      end

      # Показывает напоминания типа: "вы успешно авторизировались"
      def notice
	partial 'shared/notice'
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
	partial 'shared/engine_head'
      end

      def hide_me_if(something)
	yield unless something
      end

      # put thin in place where you want admin panel appear
      def admin_panel
	partial 'shared/administrator_panel' if logged_in?('root','manager')
      end

      #--
      #подумать_start
      def login_form#:nodoc:
	partial 'shared/login_form' unless logged_in?
      end

      def nodes_from(page, count=5)#:nodoc:
	nodes = Page.find_by_link(page.to_s).nodes.find(:all, :limit => count, :order => "created_at DESC")
	partial 'shared/news', :nodes => nodes
      rescue
        %Q(no such page '#{page.to_s}')
      end
      #поддумать_end
      #++

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

      #--
      # Engine specific
      def title(text)#:nodoc:
	content_tag :h1, text
      end

      def link_to_new(path)#:nodoc:
	link_to engine_image('add.png'), path
      end

      def link_to_edit(something,path)#:nodoc:
	link_to something.capitalize, path
      end

      def link_to_cancel(path)#:nodoc: #TODO путь назад должен быть предыдущим урл(мабуть)
	link_to t(:cancel)+engine_image('cancel.png'), path
      end

      def link_to_destroy(something)#:nodoc:
	link_to engine_image('delete.png'), something, :confirm => t("Are you sure?"), :method => :delete
      end
      def partial(view, params = nil)#:nodoc:
	render :partial => view, :locals => params
      end

      def engine_image(source,options={})#:nodoc:
	image_tag "/jjane/images/#{source}", options.merge(:style => 'vertical-align:middle; border:none;')
      end
    end
  end
end
