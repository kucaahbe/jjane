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

      # navigation menu based on unordered lists
      # name - name of menu to display
      def menu menu_name = 'main', options = {}
	default_options = {
	  :dir_class         =>    'dir',
	  :active_dir_class  => 'active',
	  :active_link_class => 'active'
	}
	html_options = default_html_options = { :id => 'nav' }
	html_options = default_html_options.merge(options[:html]) if options[:html]
	options.delete(:html)
	options = default_options.merge(options)

	if options[:for_page]
	  collection = Page.find_by_name(options[:for_page]).self_and_descendants
	else
	  collection = Page.find(:all, :order => 'lft ASC')
	end
	pages = []
	Page.each_with_level(collection) do |page,level|
	  pages << {
	    :url => page.url,
	    :menu => page.menu,
	    :level => level,
	    :visible => page.visible_in_menu?(menu_name)
	  }
	end
	pages.map! do |p|
	  if p == pages.last
	    p.update :have_children => false
	  else
	    p.update(:have_children => p[:level] < pages[pages.index(p)+1][:level])
	  end
	end

	menu_ = %[<ul id="#{html_options[:id]}" class="#{html_options[:class]}">\n]
	pages.each_index do |i|
	  previous = i==0 ? nil : pages[i-1]; current = pages[i]

	  l = ' '*current[:level]

	  insert_active_dir_class = false
	  if defined?(@page) && current[:url] == @page.url
	    link = %[<a href="#{root_url+current[:url]}" class="#{options[:active_link_class]}">#{current[:menu]}</a>]
	    insert_active_dir_class = true
	  else
	    link = %[<a href="#{root_url+current[:url]}">#{current[:menu]}</a>]
	  end

	  menu_ += %[#{l}</ul>\n</li>\n] if previous and current[:level] < previous[:level]

	  if current[:have_children]
	    menu_ += %[#{l}<li class="#{options[:dir_class]}#{insert_active_dir_class ? ' '+options[:active_dir_class].to_s : ''}">\n]
	  else
	    menu_ += %[#{l}<li#{insert_active_dir_class ? ' class="'+options[:active_dir_class].to_s+'"' : ''}>]
	  end

	  menu_ += link

	  if current[:have_children] 
	    menu_ += "#{l}\n<ul>\n"
	  else
	    menu_ += "</li>\n"
	  end
	  menu_ += "</ul>\n</li>"*current[:level] if pages[i] == pages.last
	end
	logger.info menu_ += "</ul>"
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
