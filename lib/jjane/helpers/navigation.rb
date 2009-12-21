module JJane
  module Helpers
    module Navigation

      # меню навигации(Главная > Каталог > жопа с ручкой)
      def nav_menu(args={})
	default_options = {
	  :include_self => true,
	  :before => '',
	  :after => '',
	  :separator => '&nbsp;&raquo;&nbsp;'
	}
	args = default_options.merge(args)

	line = args[:before]
	@page.ancestors.each do |page|
	  line += link_to(page.menu, root_url+page.url) + args[:separator]
	end
	line += link_to(@page.menu,root_url+@page.url) + args[:after] if args[:include_self]

	return line
      rescue
	''
      end

      # рисует менюхи список страниц в том порядке в котором они есть
      def ul_li_menu(name='main',args={})
	default_options = {
	  :roots_only => false
	}
	default_html_options = {
	  :id => 'nav',
	  :class =>'',
	  :dir_class => 'dir'
	}
	args[:html] = default_html_options.merge(args[:html])
	args = default_options.merge(args)

	view = ''
	Page.roots.each do |root|
	  view += partial(
	  'shared/ul_li_menu',
	  :page => root,
	  :menu_name => name,
	  :roots_only => args[:roots_only],
	  :dir_class => args[:html][:dir_class]
	  )
	end
	content_tag :ul, view, :id => args[:html][:id], :class => args[:html][:class]
      end

    end
  end
end
