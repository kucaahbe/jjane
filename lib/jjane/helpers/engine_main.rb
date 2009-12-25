module JJane
  module Helpers
    module EngineMain#:nodoc:
      def title(text)
	content_tag :h1, text
      end

      def link_to_new(path)
	link_to engine_image('add.png'), path
      end

      def link_to_edit(something,path)
	link_to something.capitalize, path
      end

      def link_to_cancel(path)#TODO путь назад должен быть предыдущим урл(мабуть)
	link_to t(:cancel)+engine_image('cancel.png'), path
      end

      def link_to_destroy(something)
	link_to engine_image('delete.png'), something, :confirm => t("Are you sure?"), :method => :delete
      end
      def partial(view, params = nil)
	render :partial => view, :locals => params
      end

      def engine_image(source,options={})
	image_tag "/jjane/images/#{source}", options.merge(:style => 'vertical-align:middle; border:none;')
      end

      # tabs
      def tab_header(*tabnames)
	tabnames = tabnames.to_a
	def wrap(text,n,l,active=false)
	  return "\n"+content_tag( :li,
              				  link_to("<span>#{text}</span>", 'javascript:void(0)',
					  :onclick => "toggleTab(#{n},#{l},null,false)",
                                	  :class => :tablink),
 				   :id => active ? "tabHeaderActive":"tabHeader#{n}" )
	end
	list = wrap(tabnames[0],1,tabnames.length,true )
	tabnames[1..tabnames.length].each_index do |n|
	  list += wrap(tabnames[n+1],n+2,tabnames.length)
	end
	content_tag :ul do
	  list
	end
      end
    end
  end
end
