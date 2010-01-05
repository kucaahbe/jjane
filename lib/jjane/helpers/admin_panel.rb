module JJane
  module Helpers
    module AdminPanel#:nodoc:

      def pages_link
	link_to engine_image('pages.png'),
	  pages_path,
	  :title => t(:link_title_pages_path)
      end

      def users_link
	link_to engine_image('users.png'),
	  users_path,
	  :title => t(:link_title_users_path)
      end

      def snippets_link
	link_to engine_image('snippets.png'),
	  snippets_path,
	  :title => t(:link_title_snippets_path)
      end

      def filesystem_link
	#link_to engine_image('filesystem.png'),
	#  attached_files_path,
	#  :title => t(:filemanager)
      end

      def item_name
	if action_name!='node'
      "page"
	else
      "node"
	end if controller_name=='site'
      end

      def crud_actions
	case item_name
	when 'page'
	  edit_page_link + destroy_page_link + new_node_link
	when 'node'
	  edit_node_link + destroy_node_link
	end
      end

      def edit_page_link
	link_to engine_image('pencil.png'),
	  edit_page_path(@page),
	  :title => t(:link_title_edit_page)
      end

      def destroy_page_link
	link_to engine_image('delete.png'), @page, :confirm => t(:question_are_you_shure), :method => :delete,
	  :title => t(:link_title_destroy_page)
      end

      def new_node_link
	unless Page.static_page_types.include?(@page.page_type)
	  link_to engine_image('add.png'),
	    new_page_node_path(@page.id,@page.page_type),
	    :title => t(:link_title_new_node)
	else
          ''
	end
      end

      def edit_node_link
	link_to engine_image('pencil.png'),
	  edit_page_node_path(@page.id,@page.page_type,@node),
	  :title => t(:link_title_edit_node)
      end

      def destroy_node_link
	link_to engine_image('delete.png'), page_node_path(@page,@page.page_type,@node), :confirm => t(:question_are_you_shure), :method => :delete,
	  :title => t(:link_title_destroy_node)
      end

    end
  end
end
