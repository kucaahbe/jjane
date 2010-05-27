class PagesController < AdminController#:nodoc:

  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_page, :only => [:edit, :update, :destroy]
  before_filter :calculate_page_types, :only => [:new, :create]

  def index
    @pages = []
    Page.each_with_level( Page.find(:all, :order => 'lft ASC') ) do |page,level| 
      @pages << {
	:page => page,
	:id => dom_id(page),
	:class => dom_class(Page),
	:level => level
      }
    end
    @pages[0..-2].map! { |p| p.update(:have_children => p[:level] < @pages[@pages.index(p)+1][:level]) }
    @pages[-1].update :have_children => false
    @menus_columns = Page.menus_columns
  end

  def new
    if params[:page_id]
      @page = Page.new(:parent_id => params[:page_id])
    else
      @page = Page.new
    end
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
      notice Page, :updated
      redirect_to edit_page_path(@page)
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
