module JJane
  module Helpers
    module EngineMainHelper#:nodoc:

      def title(text)
	content_tag :h1, text, :class => 'jjane-title jjane'
      end

      #--
      # engine links start
      #++
      def link_to_new(path)
	link_to engine_image('add.png'), path
      end

      def link_to_edit(something,path)
	link_to something.capitalize, path
      end

      def link_to_cancel(path)#TODO путь назад должен быть предыдущим урл(мабуть)
	link_to t(:link_cancel)+engine_image('cancel.png'), path
      end

      def link_to_destroy(path)
	link_to engine_image('delete.png'), path, :confirm => t(:question_are_you_shure), :method => :delete
      end
      #--
      # engine links end
      #++

      def partial(view, params = nil)
	render :partial => view, :locals => params
      end

      def engine_image(source,options={})
	image_tag "/jjane/images/#{source}", options.merge(:style => "#{options[:style]} vertical-align:middle; border:none;")
      end

      def warning(text)
	%Q(<span class="jjane" style="color:red; text-weight:bold;">#{text}</span>)
      end
    end
  end
end
