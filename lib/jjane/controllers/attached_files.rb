class AttachedFilesController < ApplicationController#:nodoc:
  before_filter :new_items_init, :only => [:index, :show]
  before_filter :check_access

  def index
    @files = AttachedFile.roots.sort
  end

  def show
    @updir = AttachedFile.find(params[:id])
    @files = @updir.children.sort
    @breadcrumbs = @updir.self_and_ancestors
    render :action => :index
  end

  def edit
    @attached_file = AttachedFile.find(params[:id])
  end

  def create
    @attached_file = AttachedFile.new(params[:attached_file])

    if @attached_file.save
      notice AttachedFile, :created
      if @attached_file.parent_id
	redirect_to :action => :show, :id => @attached_file.parent_id, :type => params[:type]
      else
	redirect_to :action => :index, :type => params[:type]
      end
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
      if @attached_file.parent_id
	redirect_to :action => :show, :id => @attached_file.parent_id, :type => params[:type]
      else
	redirect_to :action => :index, :type => params[:type]
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @attached_file = AttachedFile.find(params[:id])
    parent_id = @attached_file.parent_id
    @attached_file.destroy

    if parent_id
      redirect_to :action => :show, :id => parent_id, :type => params[:type]
    else
      redirect_to :action => :index, :type => params[:type]
    end
  end

  private

  def new_items_init
    @new_dir = AttachedFile.new(:directory_id => params[:id])
    @new_file = AttachedFile.new(:directory_id => params[:id])
  end
end
