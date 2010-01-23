module JJane
  module Helpers
    module EngineMainHelper#:nodoc:

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
	link_to t(:link_cancel)+engine_image('cancel.png'), path
      end

      def link_to_destroy(something)
	link_to engine_image('delete.png'), something, :confirm => t(:question_are_you_shure), :method => :delete
      end
      def partial(view, params = nil)
	render :partial => view, :locals => params
      end

      def engine_image(source,options={})
	image_tag "/jjane/images/#{source}", options.merge(:style => 'vertical-align:middle; border:none;')
      end

      def warning(text)
	%Q(<span class="warning">#{text}</span>)
      end
    end
  end
end
