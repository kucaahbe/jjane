class NodesController < AdminController
  prepend_view_path 'app/views/nodes'

  before_filter :find_page

  private

  def find_page
    @page = Page.find(params[:page_id])
  end
end
