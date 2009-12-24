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
    end
  end
end
