module JJane
  module Helpers
    module CoreHelper
      include JJane::Helpers::NavHelper
      include JJane::Helpers::AdminPanelHelper
      include JJane::Helpers::UserSessionHelper

      def title(text)
	content_tag :h1, text
      end

      def link_to_new(path)
	link_to engine_image('add.png'), path
      end

      def link_to_edit(something,path)
	link_to something.capitalize, path
      end

      def link_to_cancel(path)#TODO путь назад должен быть предыдущим урл(мабуть)
	link_to 'cancel '+engine_image('cancel.png'), path
      end

      def link_to_destroy(something)
	link_to engine_image('delete.png'), something, :confirm => "Are you sure?", :method => :delete
      end

      def partial(view, params = nil)
	render :partial => view, :locals => params
      end

      def engine_image(source,options={})
	image_tag "/jjane/images/#{source}", options.merge(:align => :middle)
      end

      # Показывает напоминания типа: "вы успешно авторизировались"
      def notice
	partial 'shared/notice'
      end

      # добавляет CSS файл
      def stylesheet(*args)
	stylesheet_link_tag(*args.map(&:to_s))
      end

      # добавляет java-скрипт
      def javascript(*args)
	args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
	javascript_include_tag(*args)
      end

      # дефолтовые сццки рисует для движка
      def engine_head
	partial 'shared/engine_head'
      end

      def hide_me_if(something)
	yield unless something
      end

      # Если пользователь залогинился показывает панель управления
      def admin_panel
	partial 'shared/administrator_panel' if logged_in?('root','manager')
      end

      def login_form
	partial 'shared/login_form' unless logged_in?
      end

      def nodes_from(page, count=5)
	nodes = Page.find_by_link(page.to_s).nodes.find(:all, :limit => count, :order => "created_at DESC")
	partial 'shared/news', :nodes => nodes
      rescue
    %Q(no such page '#{page.to_s}')
      end
    end
  end
end
