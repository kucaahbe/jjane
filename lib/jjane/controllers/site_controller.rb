class SiteController < ApplicationController

  before_filter :check_uri, :except => [:home_page]
  before_filter :check_node, :only => [:node]

  def home_page
    @page = Page.home_page
    @nodes = @page.nodes.paginate :page => params[:page], :per_page => @page.pagination, :order => 'updated_at DESC'
    render "/pages/#{@page.page_type}/show", :layout => @page.layout
  end

  def page
    @nodes = @page.nodes.paginate :page => params[:page], :per_page => @page.pagination, :order => 'updated_at DESC'
    render "/pages/#{@page.page_type}/show", :layout => @page.layout
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

  # checks uri for exstence
  def check_uri#:doc:
    # @page => current page
    url = params[:uri].join('/')
    page = Page.find_by_url(url)
    @page = page unless page.nil?
    error_404 unless defined?(@page)
  end

  def check_node#:doc:
    @node = @page.nodes.find(params[:id])
  rescue
    error_404
  end
end
