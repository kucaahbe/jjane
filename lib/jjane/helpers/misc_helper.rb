class JJane
  module Helpers

    module TableHelper
      def table_for nodes, width, html_options={}, &block
	raise ArgumentError, "Missing block" unless block_given?
	JJane::Helpers::TableBuilder.new(nodes,width,html_options,self,&block)
      end
    end

    class TableBuilder#:nodoc:
      #TODO height option
      def initialize nodes, width, html_options, template, &block
	@template = template
	length = nodes.length

	result = @template.tag(:table, html_options, true)

	(length/width).times do |i|
	  result += "<tr>\n"
	  nodes[i*width,width].each do |node|
	    result += @template.content_tag(:td,
					    if @template.send :block_called_from_erb?, block
					      @template.send :capture, node, &block
					    else
					      yield(node)
					    end
					   )
	  end
	  result += "</tr>\n"
	end

	# ostatok
	left = nodes[(length/width)*width,width]
	unless left.empty?
	  result += "<tr>\n"
	  left.each do |node|
	    result += @template.content_tag(:td,
					    if @template.send :block_called_from_erb?, block
					      @template.send :capture, node, &block
					    else
					      yield(node)
					    end
					   )
	  end
	  result += "</tr>\n"
	end

	result += '</table>'

	if @template.send :block_called_from_erb?, block
	  @template.send :concat, result
	else
	  result
	end
      end
    end

    class TabbarBuilder#:nodoc:

      def initialize template
	@template = template
      end

      # tabbar headers
      def headers *tabnames
	tabnames = tabnames.to_a
	list = ''
	tabnames.each_index { |number| list += wrap tabnames[number], "#fragment-#{number+1}" }
	@template.content_tag :ul, list
      end

      # tabbar content
      def content &block
	raise ArgumentError, "Missing block" unless block_given?
	@number ||= -1;	@number += 1

	result = @template.content_tag :div, @template.capture(&block), :id => "fragment-#{@number+1}"

	if @template.send :block_called_from_erb?, block
	  @template.send :concat, result
	else
	  result
	end
      end

      private

      def wrap text,link
	%[<li><a href="#{link}"><span>#{text}</span></a></li>]
      end
    end


    #    <% tabbar do |tabbar| %>
    #      <%= tabs.headers 'tab name' %>
    #      <% tabs.content do %>
    #          'tabs content'
    #      <% end %>
    module TabbarHelper

      # writes tabbar
      def tabbar(html_options={}, &block)
	raise ArgumentError, "Missing block" unless block_given?
	options = { :id => 'tabs', :class => 'jjane' }.merge(html_options)

	result = content_tag(:div, capture(JJane::Helpers::TabbarBuilder.new(self),&block), options)

	content_for :head do
	  javascript('/jjane/javascripts/jquery.cookie.js')+
	    stylesheet('/jjane/stylesheets/jquery-ui/style')+
	    javascript_tag('$(document).ready( function() { $("#tabs").tabs({ cookie: { expires: 30 } }); } );')
	end

	if block_called_from_erb?(block)
	  concat(result)
	else
	  result
	end
      end
    end
  end
end

ActionView::Base.class_eval { include JJane::Helpers::TabbarHelper }
ActionView::Base.class_eval { include JJane::Helpers::TableHelper }
