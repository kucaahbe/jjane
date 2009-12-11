module JJane
  module Controllers
    class Site < ApplicationController
      before_filter :check_uri, :except => [:home_page]
      before_filter :check_node, :only => [:node]

      def home_page
	@page = Page.home_page
	@title = @page.title
	#@nodes = @page.nodes #TODO after finishing nodes
	render "/pages/#{@page._type_}/show", :layout => @page._layout_
      end

      def page
	@title = @page.title
	#@nodes = @page.nodes
	render "/pages/#{@page._type_}/show", :layout => @page._layout_
      end

      def node
	@title = @node.title
	render 'node', :layout => @page._layout_
      end

      def find_by_day
	@title = @page.title
	date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
	@nodes = @page.nodes.find(:all, :conditions => { :created_at => date.beginning_of_day..date.end_of_day })
	unless @nodes.empty?
	  render @page._type_, :layout => @page._layout_
	else
	  render :text => '<p style="text-align:center;">нет материала за выбранный период</p>', :layout => @page._layout_
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
	@node = Node.find(params[:id])
	error_404 unless @node.page===@page
      end
    end
  end
end
