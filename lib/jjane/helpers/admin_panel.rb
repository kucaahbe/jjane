module JJane
  module Helpers
    module AdminPanel

      def pages_link
	link_to engine_image('pages.png'),
	  pages_path,
	  :title => t(:edit_pages)
      end

      def users_link
	link_to engine_image('users.png'),
	  users_path,
	  :title => t(:edit_users)
      end

      def snippets_link
	link_to engine_image('snippets.png'),
	  snippets_path,
	  :title => t(:edit_snippets)
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
	  :title => t(:edit_page)
      end

      def destroy_page_link
	link_to engine_image('delete.png'), @page, :confirm => "Are you sure?", :method => :delete,
	  :title => t(:delete_page)
      end

      def new_node_link
	if @page._type_!='static'
	  link_to engine_image('add.png'),
	  new_page_node_path(@page.id,@page._type_),
	  :title => t(:new_node)
	else
      ''
	end
      end

      def edit_node_link
	link_to engine_image('pencil.png'),
	  edit_page_node_path(@page.id,@page._type_,@node),
	  :title => t(:edit_node)
      end

      def destroy_node_link
	link_to engine_image('delete.png'), page_node_path(@page,@page._type_,@node), :confirm => "Are you sure?", :method => :delete,
	  :title => t(:destroy_node)
      end

    end
  end
end
