class PagesController < JJaneAdminController
  handles_sorting_of_nested_set

  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_page, :only => [:edit, :update, :destroy]

  def index
    @roots = JJanePage.roots
    @menus_columns = JJanePage.menus_columns
  end

  def sort
    @page = JJanePage.find(params[:moved_page_id])
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
      @page = JJanePage.new(:parent_id => params[:page_id])
    else
      @page = JJanePage.new
    end
  end

  def edit
  end

  def create
    @page = JJanePage.new(params[:page])

    if @page.save
      notice JJanePage, :created
      redirect_to pages_path
    else
      render :action => "new"
    end
  end

  def update
    if @page.update_attributes(params[:page])
      notice JJanePage, :updated
      redirect_to edit_page_path(@page)
    else
      notice_error JJanePage, :updated
      render :action => "edit"
    end
  end

  def destroy
    @page.destroy

    redirect_to pages_path
  end

  private

  def find_page
    @page = JJanePage.find(params[:id])
  end

end
