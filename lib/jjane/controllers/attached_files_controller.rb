class AttachedFilesController < AdminController
  def index
    @files = AttachedFile.roots
    @files.sort! { |one,two| one.name <=> two.name }
  end

  def show
    @updir = AttachedFile.find(params[:id])
    @files = @updir.children
    @files.sort! do |one,two|
      if one.directory? and two.directory?
	one.name <=> two.name
      else
	one.directory? ? -1 : 1
      end
    end
    render :action => :index
  end

  def new
    @attached_file = AttachedFile.new( params[:attached_file_id] ? {:directory_id => params[:attached_file_id]} : nil )
  end

  def new_file
    @attached_file = AttachedFile.new( :directory_id => params[:attached_file_id] )
    render :action => :new
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
      render :action => "new"
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
end
