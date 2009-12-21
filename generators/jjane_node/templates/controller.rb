class <%= controller_class_name %>Controller < JJaneAdminController

  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_page
  before_filter :find_<%= node_name %>, :except => [:new, :create]

  def new
    @<%= node_name %> = <%= class_name %>.new
    @<%= node_name %>.page = @page
    @<%= node_name %>.user = current_user
    render '/nodes/<%= node_table_name %>/new', :layout => @page._layout_
  end

  def create
    @<%= node_name %> = <%= class_name %>.new(params[:<%= node_name %>])
    if @<%= node_name %>.save
      notice <%= class_name %>, :created
      redirect_to show_node_path(@page.url,@<%= node_name %>)
    else
      render '/nodes/<%= node_table_name %>/new', :layout => @page._layout_
    end
   
  end

  def edit
    render '/nodes/<%= node_table_name %>/edit', :layout => @page._layout_
  end

  def update
    if @<%= node_name %>.update_attributes(params[:<%= node_name %>])
      notice <%= class_name %>, :updated
      redirect_to edit_page_node_path(@page,@page._type_,@<%= node_name %>)
    else
      render '/nodes/<%= node_table_name %>/edit', :layout => @page._layout_
    end
  end

  def destroy
    @<%= node_name%>.destroy

    redirect_to show_page_url(@page.url)
  end

  private

  def find_<%= node_name %>
    @<%= node_name %> = <%= class_name %>.find(params[:id])
  end

  def find_page
    @page = Page.find(params[:page_id])
  end
end
