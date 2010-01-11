module JJane#:nodoc:
  module Routing #:nodoc:
    # Adds routing extensions
    #
    # sample config/routes.rb file:
    #  ActionController::Routing::Routes.draw do |map|
    #
    #    map.jjane_admin 'administration'
    #    map.jjane_root
    #    map.jjane_connect
    #  end
    module MapperExtensions
      #   map.welcome 'path_to_admin_login', :controller => :admin, :action => :welcome
      def jjane_admin(path_to_admin_login = 'admin')
	welcome path_to_admin_login, :controller => :login, :action => :welcome
      end

      # it is the same as 
      #   map.root :controller => :site, :action => :home_page
      def jjane_root
	root :controller => :site, :action => :home_page
      end

      def jjane_connect
	resources :attached_files do |m|
	  m.resource :directory, :controller => :attached_files, :only => :new
	  m.upload 'file/new', :controller => :attached_files, :action => :new_file
	end

	connect        'pages/:page_id/:controller',          :action => :create,  :conditions => { :method => :post }
	new_page_node  'pages/:page_id/:controller/new',      :action => :new,     :conditions => { :method => :get }
	edit_page_node 'pages/:page_id/:controller/:id/edit', :action => :edit,    :conditions => { :method => :get }
	page_node      'pages/:page_id/:controller/:id',      :action => :update,  :conditions => { :method => :put }
	connect        'pages/:page_id/:controller/:id',      :action => :destroy, :conditions => { :method => :delete }

	resources :pages, :except => [:show], :collection => { :sort => :put } do |page|
	  page.resources :child, :controller => :pages, :only => [:new]
	end
	resources :snippets, :except => [:show]
	resources :users
	login   '__login__',  { :controller => :login, :action => :login }
	logout  '__logout__', { :controller => :login, :action => :logout }
	connect '*uri/:year/:month/:day', {
	  :controller => 'site',
	  :action     => 'find_by_day',
	  :year       => /\d{4}/,
	  :month      => /\d{1,2}/,
	  :day        => /\d{1,2}/
	}
	show_node '*uri/:id', {
	  :controller => :site,
	  :action => :node,
	  :requirements => { :id => /\d+/ }
	}
	show_page '*uri', {
	  :controller => :site,
	  :action => :page
	}
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, JJane::Routing::MapperExtensions
