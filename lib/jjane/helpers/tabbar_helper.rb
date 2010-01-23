module JJane
  module Helpers
    class TabbarBuilder

      def initialize(template)
	@template = template
	@tabnames = []
      end
      # tabbar headers
      def headers(*tabnames)
	@tabnames = tabnames = tabnames.to_a
	wrap = Proc.new do |text,n,l,active|
	    "\n"+@template.content_tag( :li,
				       @template.link_to("<span>#{text}</span>", 'javascript:void(0)',
							 :onclick => "toggleTab(#{n},#{l},null,false)",
	    :class => :tablink),
	      :id => active ? "tabHeaderActive":"tabHeader#{n}" )
	end
	list = wrap.call(tabnames[0],1,tabnames.length,true )
	tabnames[1..tabnames.length].each_index do |n|
	  list += wrap.call(tabnames[n+1],n+2,tabnames.length,false)
	end
	@template.content_tag :ul do
	  list
	end
      end

      # tabbar content
      def content(html_options={}, &block)
	raise ArgumentError, "Missing block" unless block_given?
	options = { :id => 'tabscontent', :style => 'outline:1px solid green;' }.merge(html_options)

	result = @template.content_tag(:div, @template.capture(&block), options)

	if @template.send :block_called_from_erb?, block
	  @template.send :concat, result
	else
	  result
	end
      end
    end

    module TabbarHelper

      # writes tabbar
      def tabbar(html_options={}, &block)
	raise ArgumentError, "Missing block" unless block_given?
	options = { :id => 'tabs', :style => 'outline:1px solid red;' }.merge(html_options)

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
