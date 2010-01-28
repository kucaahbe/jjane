module JJane
  module Helpers
    module NavigationHelper

      # Breadcrumbs
      #   :framing_tag (default=:div)
      #   :include_self - if true then adds current page link(default=true)
      #   :separator - wich separator use(default='&nbsp;&raquo;&nbsp;')
      #   :before - what to write before breadcrumbs(default='&nbsp;&raquo;&nbsp;')
      #   :after - what to write after breadcrumbs(default='')
      #   :include_node - if true then include node title(default=false)
      #   :before_node - what to draw before node(if :include_node specified)
      #   :after_node - what to draw after node(if :include_node specified)
      #   :html - hash of html options for :framing_tag
      def breadcrumbs(options={})
	if controller_name=='site' then
	  default_options = {
	    :framing_tag => :div,
	    :include_self => true,
	    :before => '',
	    :after => '',
	    :separator => '&nbsp;&raquo;&nbsp;',
	    :include_node => false,
	    :before_node => '',
	    :after_node => ''
	  }
	  default_html_options = { :id => 'breadcrumbs' }

	  if options[:html]
	    options[:html] = default_html_options.merge(options[:html])
	  else
	    options[:html] = default_html_options
	  end
	  options = default_options.merge(options)

	  line = options[:before]
	  @page.ancestors.each do |page|
	    line += link_to(page.menu, root_url+page.url) + options[:separator]
	  end
	  line += link_to(@page.menu,root_url+@page.url) if options[:include_self]

	  if defined?(@node) && options[:include_node]
	    line += options[:separator] +
	      options[:before_node] +
	      content_tag(:span,link_to(@node.title,root_url+@node.url),:class => 'node') +
	      options[:after_node]
	  end

	  line += options[:after]

	  content_tag options[:framing_tag], line, options[:html]
	end
      end

      # UL LI navigation menu
      def ul_li_menu(name='main',options={})
	default_options = {
	  :roots_only => false,
	  :dir_class => 'dir',
	  :active_class => 'active',
	  :active_link_class => 'active'
	}
	default_html_options = { :id => 'nav' }

	if options[:html]
	  options[:html] = default_html_options.merge(options[:html])
	else
	  options[:html] = default_html_options
	end
	options = default_options.merge(options)

	view = ''
	Page.roots.each do |root|
	  view += partial(
	  'shared/ul_li_menu',
	  :page => root,
	  :menu_name => name,
	  :roots_only => options[:roots_only],
	  :dir_class => options[:dir_class],
	  :active_class => options[:active_class],
	  :active_link_class => options[:active_link_class]
	  )
	end
	content_tag :ul, view, options[:html]
      end

      # Draws link to page specified by it's unique ID
      def link_to_page(name, page_name, options={})
	link_to name, root_url+Page.find_by_name(page_name.to_s).url, options
      rescue
	warning("no such page with ID '#{page_name}'")
      end
    end
  end
end
