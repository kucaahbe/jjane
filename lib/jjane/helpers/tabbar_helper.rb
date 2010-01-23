module JJane
  module Helpers
    class TabbarBuilder

      class Content
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
	  @template.link_to("<span>#{text}</span>", 'javascript:void(0)', :onclick => "toggleTab(#{n},#{l},null,false)", :class => :tablink),
     	  :id => active ? "tabHeaderActive":"tabHeader#{n}" 
      end
    end

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
