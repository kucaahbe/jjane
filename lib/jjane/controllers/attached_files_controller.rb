class AttachedFilesController < AdminController
  before_filter :new_items_init, :only => [:index, :show]

  def index
    @files = AttachedFile.roots
    @files.sort!
  end

  def show
    @updir = AttachedFile.find(params[:id])
    @files = @updir.children
    @breadcrumbs = @updir.self_and_ancestors
    @files.sort!
    render :action => :index
  end

  def edit
    @attached_file = AttachedFile.find(params[:id])
  end

  def create
    @attached_file = AttachedFile.new(params[:attached_file])

    if @attached_file.save
      notice AttachedFile, :created
      redirect_to (@attached_file.parent || {:action => :index})
    else
      new_items_init
      if @attached_file.directory?
	@new_dir = @attached_file
      else
	@new_file = @attached_file
      end
      self.index
      render :action => :index
    end
  end

  def update
    @attached_file = AttachedFile.find(params[:id])

    if @attached_file.update_attributes(params[:attached_file])
      notice AttachedFile, :updated
      redirect_to (@attached_file.parent || {:action => :index})
    else
      render :action => "edit"
    end
  end

  def destroy
    @attached_file = AttachedFile.find(params[:id])
    parent = @attached_file.parent
    @attached_file.destroy

    redirect_to (parent || {:action => :index})
  end

  private

  def new_items_init
    @new_dir = AttachedFile.new(:directory_id => params[:id])
    @new_file = AttachedFile.new(:directory_id => params[:id])
  end
end
