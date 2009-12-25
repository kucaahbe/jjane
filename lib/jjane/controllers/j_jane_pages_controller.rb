class JJanePagesController < JJaneAdminController
  handles_sorting_of_nested_set

  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_page, :only => [:edit, :update, :destroy]
  before_filter :define_page_types, :only => [:new, :create]

  def index
    @roots = Page.roots
    @menus_columns = Page.menus_columns
  end

  def sort
    @page = Page.find(params[:moved_page_id])
    new_position = position_of(:moved_page_id).in_tree(:pages)

    if new_position[:parent]
      @page.move_to_child_of(new_position[:parent])
    else
      @page.move_to_root
    end unless @page.parent_id === new_position[:parent]

    if new_position[:move_to_right_of]
      @page.move_to_right_of(new_position[:move_to_right_of])
    else
      @page.move_to_left_of(new_position[:move_to_left_of])
    end

    render :update do |page| 
      page.reload 
    end
  end

  def new
    if params[:page_id]
      @page = Page.new(:parent_id => params[:page_id])
    else
      @page = Page.new
    end
  end

  def edit
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      @page.create_meta
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

  def define_page_types
    pages_dir=File.join(RAILS_ROOT,'app','views','pages','**')
    static_page_types = []
    Dir.glob(pages_dir) { |fname| static_page_types << File.basename(fname) }

    nodes_dir=File.join(RAILS_ROOT,'app','views','nodes','**')
    nodes_types = []
    Dir.glob(nodes_dir) { |fname| nodes_types << File.basename(fname) }

    static_page_types = static_page_types - nodes_types
    @page_types = { 
    'статические страницы' => static_page_types,
    'статьи' => nodes_types
    }
  end

end
