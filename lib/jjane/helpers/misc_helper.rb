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

      class Content#:nodoc:
	def initialize(template)
	  @template = template
	  @number = 0
	end

	def draw(&block)
	  @number += 1
	  result = @template.content_tag :div,
	    @template.capture(&block),
	    :id => "tabContent#{@number}",
	    :class => "tabContent",
	    :style => "display:#{@number==1 ? 'yes' : 'none'};"
	    @template.send :concat, result
	end
      end

      def initialize(template)
	@template = template
	@tabnames = []
      end

      # tabbar headers
      def headers(*tabnames)
	@tabnames = tabnames = tabnames.to_a
	list = wrap(tabnames[0],1,tabnames.length,true)
	tabnames[1..tabnames.length].each_index do |n|
	  list += wrap(tabnames[n+1],n+2,tabnames.length,false)
	end
	@template.content_tag :ul, list
      end

      # tabbar content
      def content(html_options={}, &block)
	raise ArgumentError, "Missing block" unless block_given?
	options = { :id => 'tabscontent' }.merge(html_options)

	result = @template.content_tag(:div, @template.capture(Content.new(@template),&block), options)

	if @template.send :block_called_from_erb?, block
	  @template.send :concat, result
	else
	  result
	end
      end

      private

      def wrap(text,n,l,active)
	@template.content_tag :li,
	  @template.link_to(
	  "<span>#{text}</span>",
	  'javascript:void(0)',
	  :onclick => "toggleTab(#{n},#{l},null,false)",
	:class => :tablink),
	  :id => active ? "tabHeaderActive":"tabHeader#{n}" 
      end
    end


    #    <% tabbar do |tabbar| %>
    #      <%= tabs.headers 'tab name' %>
    #      <% tabs.content do |tabcontent| %>
    #        <% tabcontent.draw do %>
    #          'tabs content'
    #        <% end %>
    #    <% end %>
    module TabbarHelper

      # writes tabbar
      def tabbar(html_options={}, &block)
	raise ArgumentError, "Missing block" unless block_given?
	options = { :id => 'tabs' }.merge(html_options)

	result = content_tag(:div, capture(JJane::Helpers::TabbarBuilder.new(self),&block), options)

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
