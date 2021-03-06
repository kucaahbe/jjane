class PagesController < AdminController#:nodoc:

  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_page, :only => [:edit, :update, :destroy]
  before_filter :calculate_page_types, :only => [:new, :create]

  def sort
    @page = Page.find(params[:id])
    begin
      if params[:args]===''
	@page.send params[:mover].to_sym
      else
	@page.send params[:mover].to_sym, params[:args].to_i
      end
    rescue
      @flash[:error] = $!
    end
    render :update do |page|
      page.reload
    end
  end

  def index
    @pages = []
    levels = []
    Page.each_with_level( Page.find(:all, :order => 'lft ASC') ) { |page,level| @pages << { :page => page, :level => level }; levels<<level }
    @max_level = levels.uniq.sort.last
    @menus = Page.menus
    render :sorting if params[:sorting]
  end

  def new
    @page = Page.new(:parent_id => params[:page_id])
    @page.user = current_user
  end

  def edit
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      notice Page, :created
      redirect_to pages_path
    else
      render :action => "new"
    end
  end

  def update
    if @page.update_attributes(params[:page])
      if request.xhr?
	render :update do |page|
	  page.reload
	end
      else
	notice Page, :updated
	redirect_to edit_page_path(@page)
      end
    else
      notice_error Page, :updated
      render :action => "edit"
    end
  end

  def destroy
    @page.destroy

    redirect_to pages_path
  end

  private

  def find_page
    @page = Page.find(params[:id])
  end

  def calculate_page_types
    @page_types = {
      t(:page_type_static) => Page.static_page_types,
      t(:page_type_nodes) => Page.nodes_types,
      t(:page_type_special) => ['directory']
    }
  end
end
