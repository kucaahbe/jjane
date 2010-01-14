module JJane
  module Helpers
    module Navigation

      # Breadcrumbs
      #   :include_self - if true then adds current page link
      #   :separator - wich separator use,default: '&nbsp;&raquo;&nbsp;'
      #   :before - what to write before breadcrumbs
      #   :after - what to write after breadcrumbs
      #   :include_node - if true then include node title
      def breadcrumbs(args={})
	default_options = {
	  :include_self => true,
	  :before => '',
	  :after => '',
	  :separator => '&nbsp;&raquo;&nbsp;',
	  :include_node => false
	}
	args = default_options.merge(args)

	line = args[:before]
	@page.ancestors.each do |page|
	  line += link_to(page.menu, root_url+page.url) + args[:separator]
	end
	line += link_to(@page.menu,root_url+@page.url) if args[:include_self]

	line += args[:separator] + link_to(@node.title,root_url+@node.url)  if defined?(@node) && args[:include_node]

	line += args[:after]

	return line
      rescue
	''
      end

      # UL LI navigation menu
      def ul_li_menu(name='main',args={})
	default_options = {
	  :roots_only => false
	}
	default_html_options = {
	  :id => 'nav',
	  :class =>'',
	  :dir_class => 'dir',
	  :active_class => 'active',
	  :active_link_class => 'active'
	}

	if args[:html]
	  args[:html] = default_html_options.merge(args[:html])
	else
	  args[:html] = default_html_options
	end
	args = default_options.merge(args)

	view = ''
	Page.roots.each do |root|
	  view += partial(
	  'shared/ul_li_menu',
	  :page => root,
	  :menu_name => name,
	  :roots_only => args[:roots_only],
	  :dir_class => args[:html][:dir_class],
	  :active_class => args[:html][:active_class],
	  :active_link_class => args[:html][:active_link_class]
	  )
	end
	content_tag :ul, view, :id => args[:html][:id], :class => args[:html][:class]
      end

    end
  end
end
