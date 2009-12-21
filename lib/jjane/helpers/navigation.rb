module JJane
  module Helpers
    module Navigation

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
