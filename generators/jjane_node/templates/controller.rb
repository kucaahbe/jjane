class <%= controller_class_name %>Controller < NodesController
  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_<%= node_name %>, :except => [:index, :new, :create]

  def index
    @nodes = @page.nodes.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def show
    self.class.layout @page.layout
    @node = <%= class_name %>.new(params[:<%= node_name %>])
  end

  def new
    @<%= node_name %> = <%= class_name %>.new(:page_id => params[:page_id], :user_id => current_user.id)
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
    @node = @<%= node_name %> = <%= class_name %>.find(params[:id])
  end
end
