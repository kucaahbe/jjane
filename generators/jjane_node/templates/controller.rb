class <%= controller_class_name %>Controller < AdminController

  prepend_view_path 'app/views/nodes'

  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_page
  before_filter :find_<%= node_name %>, :except => [:new, :create]

  def new
    @<%= node_name %> = <%= class_name %>.new(:page_id => params[:page_id], :user_id => current_user.id)
    @<%= node_name %>.build_meta
  end

  def create
    @<%= node_name %> = <%= class_name %>.new(params[:<%= node_name %>])
    if @<%= node_name %>.save
      notice <%= class_name %>, :created
      redirect_to show_node_path(@page.url,@<%= node_name %>)
    else
      render :action => :new
    end

  end

  def edit
  end

  def update
    if @<%= node_name %>.update_attributes(params[:<%= node_name %>])
      notice <%= class_name %>, :updated
      redirect_to edit_page_node_path(@page,@page.page_type,@<%= node_name %>)
    else
      render :action => :edit
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
