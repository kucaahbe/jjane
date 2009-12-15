module JJane
  module Helpers
    module Navigation

      # :range - откуда до куда начинать
      # :recursive => true рекурсивно
      #
      def navigation()
      end

      #TODO добавить options[:html]
      def contents_menu(name='main',opts={:id => 'nav', :roots_only => false})
	#log opts[:roots_only] #FIXME задавать опции по умолчанию подсмотреть в awesome_nested_ser
	view = ''
	Page.roots.each do |root|
	  view += partial('shared/contents_menu',
			  :page => root,
			  :name => name,
			  :roots_only => opts[:roots_only])
	end
	content_tag :ul, view, :id => opts[:id]
      end

    end
  end
end
