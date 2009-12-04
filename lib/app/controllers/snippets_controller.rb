class SnippetsController < AdminController #:nodoc:
  uses_tiny_mce :options=>TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  before_filter :find_snippet, :only => [:edit,:update,:destroy]

  def index
    @snippets = Snippet.all
  end
  
  def new
    @snippet = Snippet.new
  end
  
  def create
    @snippet = Snippet.new(params[:snippet])
    if @snippet.save
      notice :created
      redirect_to snippets_url
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @snippet.update_attributes(params[:snippet])
      notice :updated
      redirect_to snippets_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @snippet.destroy

    redirect_to snippets_url
  end

  private

  def find_snippet
    @snippet = find_model
  end
end
