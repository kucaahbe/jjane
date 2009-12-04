class <%= controller_class_name %>Controller < AdminController
  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_<%= node_name %>, :except => [:new, :create]

  def new
    @<%= node_name %> = <%= class_name %>.new :page_id => params[:page_id], :user_id => current_user.id
  end

  def edit
  end

  def create
    @<%= node_name %> = <%= class_name %>.new(params[:<%= node_name %>])

    if @<%= node_name %>.save
      notice :created
      redirect_to node_path(@<%= node_name %>.page.url,@<%= node_name %>)
    else
      render :action => "new"
    end
  end

  def update
    if @<%= node_name %>.update_attributes(params[:<%= node_name %>])
      notice :updated
      redirect_to node_path(@<%= node_name %>.page.url,@<%= node_name %>)
    else
      render :action => "edit"
    end
  end

  def destroy
    @page = @<%= node_name %>.page
    @<%= node_name %>.destroy

    redirect_to @page.uri
  end

  private

  def find_<%= node_name %>
    @<%= node_name %> = find_model
  end
end
