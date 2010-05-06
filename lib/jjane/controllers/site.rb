class SiteController < ApplicationController

  before_filter :check_page, :except => [:home_page]
  before_filter :check_node, :only => [:node]

  def home_page
    @page = Page.home_page
    render_page
  end

  def page
    render_page
  end

  def node
    render "/nodes/#{@page.page_type}/show", :layout => @page.layout
  end

  def find_by_day
    date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    @nodes = @page.nodes.paginate(
      :all,
      :conditions => { :created_at => date.beginning_of_day..date.end_of_day },
      :page => params[:page],
      :per_page => @page.pagination,
      :order => 'created_at DESC'
    )
    unless @nodes.empty?
      render "/pages/#{@page.page_type}/show", :layout => @page.layout
    else
      render :text => '<p style="text-align:center;">нет материала за выбранный период</p>', :layout => @page.layout
    end
  end

  private

  def render_page
    if @page.page_type=='directory'
      error_404
    else
      @nodes = @page.get_nodes(params[:page])
      render "/pages/#{@page.page_type}/show", :layout => @page.layout
    end
  end

  # checks page for exstence and publishing
  def check_page#:doc:
    # @page => current page
    url = params[:uri].join('/')
    page = Page.find_by_url(url)
    @page = page unless page.nil?
    error_404 unless defined?(@page) && @page.published?
  end

  def check_node#:doc:
    @node = @page.get_node_by_id(params[:id])
    error_404 if @node.nil?
  end
end
