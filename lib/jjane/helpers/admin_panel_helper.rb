class JJane
  module Helpers
    module AdminPanelHelper#:nodoc:

      def main_links
	link_to( engine_image('pages.png'),        pages_path,          :title => t(:admin_panel_pages) ) +
	  link_to( engine_image('users.png'),      users_path,          :title => t(:admin_panel_users) ) +
	  link_to( engine_image('snippets.png'),   snippets_path,       :title => t(:admin_panel_snippets) ) +
	  link_to( engine_image('filesystem.png'), attached_files_path, :title => t(:admin_panel_filemanager) )
      end

      def page_actions
	if defined?(@page)
	  content_tag(:span, 
		      link_to(t(:admin_panel_page)+'['+@page.name+']',root_url+@page.url) +
		      edit_page_link.to_s +
		      destroy_page_link.to_s +
		      list_nodes_link.to_s +
		      new_node_link.to_s,
		      :class => 'jjane-crud-actions'
		     )
	end
      end

      def node_actions
	if defined?(@node)
	  content_tag(:span, 
		      link_to(t(:admin_panel_node)+'['+@node.id.to_s+']',root_url+@node.url) +
		      edit_node_link.to_s +
		      destroy_node_link.to_s,
		      :class => 'jjane-crud-actions'
		     )
	end
      end

      def list_nodes_link
	unless Page.static_page_types.include?(@page.page_type)
	  link_to engine_image('nodes_list.png'), page_nodes_path(@page,@page.page_type), :title => t(:admin_panel_list_nodes)
	end
      end

      def edit_page_link
	unless controller_name=='pages' and action_name=='edit'
	  link_to engine_image('pencil.png'),
	    edit_page_path(@page),
	    :title => t(:admin_panel_edit_page)
	end
      end

      def destroy_page_link
	link_to engine_image('delete.png'), @page, :confirm => t(:question_are_you_shure), :method => :delete,
	  :title => t(:admin_panel_destroy_page)
      end

      def new_node_link
	unless Page.static_page_types.include?(@page.page_type)
	  link_to engine_image('add.png'),
	    new_page_node_path(@page.id,@page.page_type),
	    :title => t(:admin_panel_new_node)
	end
      end

      def edit_node_link
	unless action_name=='edit'
	  link_to engine_image('pencil.png'),
	    edit_page_node_path(@page.id,@page.page_type,@node),
	    :title => t(:admin_panel_edit_node)
	end
      end

      def destroy_node_link
	link_to engine_image('delete.png'), page_node_path(@page,@page.page_type,@node), :confirm => t(:question_are_you_shure), :method => :delete,
	  :title => t(:admin_panel_destroy_node)
      end

    end
  end
end
