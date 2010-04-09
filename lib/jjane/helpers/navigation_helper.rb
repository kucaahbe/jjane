class JJane
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
      def breadcrumbs options={}
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

      # simple navigation menu based on unordered lists
      # name - name of menu to display
      def menu menu_name, options = {}
	options = {
	  :dir_class         =>    'dir',
	  :active_dir_class  => 'active',
	  :active_link_class => 'active',
	  :root => nil
	}.deep_merge(options)

	ul_li_menu(menu_name,options) do |page|
	  if page[:page].page_type=='directory'
	    page[:page].menu
	  else
	    %[<a href="#{root_url+page[:page].url}" #{%[class="#{options[:active_link_class]}"] if options[:active_link_class] && page[:page]==@page}>#{page[:page].menu}</a>]
	  end
	end
      end

      # draws menu, but takes block that represent content of <li> tags
      # options:
      #   :root - ID of page,if present draws child pages of this page
      def ul_li_menu menu_name, options = {}, &block
	raise 'no block given' unless block_given?

	# collection
	if options[:root]
	  begin
	    collection = Page.find_by_name(options[:root]).self_and_descendants
	  rescue
	    collection = []
	  end
	else
	  collection = Page.find(:all, :order => 'lft ASC')
	end

	# one SQL!
	pages = []
	Page.each_with_level(collection) do |page,level|
	  pages << {
	    :page => page,
	    :level => level,
	    :visible => page.visible_in_menu?(menu_name)
	  }
	end

	# deleting invisible pages
	this_level = 0
	destroy_this_level = false
	pages.each_index do |i|
	  if destroy_this_level and (pages[i][:level] > this_level)
	    pages[i] = nil
	  else
	    this_level = pages[i][:level]
	    if pages[i][:visible]
	      destroy_this_level = false
	    else
	      destroy_this_level = true
	      pages[i] = nil
	    end
	  end
	end
	pages.compact!

	# detecting children(ето делается для избежания дополнительного SQL-запроса)
	pages[0..-2].map! do |p|
	  p.update(:have_children => p[:level] < pages[pages.index(p)+1][:level])
	end
	pages.last.update(:have_children => false) unless pages.empty?

	# draw menu
	unless pages.empty?
	  ul_li_for(pages,options,&block)
	else
	  warning('pages array empty')
	end
      end

      # Draws link to page specified by it's unique ID
      def link_to_page name, page_name, options={}
	link_to name, root_url+Page.find_by_name(page_name.to_s).url, options
      rescue
	warning("no such page with ID '#{page_name}'")
      end

      # draws raw unordered list for 'pages' array
      # each element in 'pages' must be a hash with keys:
      #   :level - deep of nesting
      #   :have_children - boolean value that represents is this item have a children
      #   :id - DOM id for <li> tag
      #   :class - DOM class for <li> tag
      # content to include in <li>...</li> generated in block given to ul_li_for,like
      #   ul_li_for(pages,options) do |page|
      #     %[<a href="#{root_url+page[:page].url}">#{page[:page].menu}</a>]
      #   end
      #
      # options:
      #   :include_framing - unclide framing <ul> and </ul> tags?(default true)
      #   :html - hash of html options(no default)
      #   :dir_class - class for using in <li> tags of objects that has children(default nil)
      #--TODO
      #   :active_dir_class что б опция бралась из блока,хехе,ебать
      #   
      #++
      def ul_li_for pages, options={}, &block
	raise 'no block given' unless block_given?

	options = {
	  :dir_class => nil,
	  :include_framing => true,
	  :html => { :id => '', :class => ''}
	}.deep_merge(options)

	menu = ''

	menu += %[<ul#{' id="'+options[:html][:id]+'"' unless options[:html][:id].empty?}#{' class="'+options[:html][:class]+'"' unless options[:html][:class].empty?}>\n] if options[:include_framing]

	pages.each_index do |i|
	  previous = i==0 ? nil : pages[i-1]; current = pages[i]

	  l = ' '*current[:level]

	  menu += %[ #{l}#{"</ul>\n#{l}</li>\n"*(previous[:level]-current[:level])}] if previous and current[:level] < previous[:level]

	  menu += l+'<li'
	  menu += ' id="'+current[:id].to_s+'"' if current[:id]
	  class_string = ''
	  class_string += options[:dir_class]+' ' if current[:have_children] && options[:dir_class]!=nil
	  class_string += current[:class] if current[:class]!=nil
	  menu += %[ class="#{class_string}"] if class_string!=''
	  menu += '>'

	  if block_called_from_erb?(block)
	    menu += capture(current,&block)
	  else
	    menu += yield(current)
	  end

	  if current[:have_children] 
	    menu += "\n #{l}<ul>\n"
	  else
	    menu += "</li>\n"
	  end
	  menu += "</ul>\n</li>"*current[:level] if pages[i] == pages.last
	end

	menu += "</ul>" if options[:include_framing]

	if block_called_from_erb?(block)
	  concat menu
	else
	  return menu
	end
      end

      # site map ul li
      def sitemap
	pages = []
	Page.each_with_level(Page.find(:all, :order => 'lft ASC')) do |page,level|
	  pages << {
	    :page => page,
	    :level => level
	  }
	end
	pages[0..-2].map! do |p|
	  p.update(:have_children => p[:level] < pages[pages.index(p)+1][:level])
	end
	pages.last.update(:have_children => false) unless pages.empty?

	ul_li_for pages do |page|
          %[<a href="#{root_url+page[:page].url}">#{page[:page].menu}</a>]
	end
      end
    end
  end
end
