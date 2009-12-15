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
      # RESTfull routes for nodes
      def jjane_resources(node_name)#-- #FIXME don't work #++
	namespace :pages do |pages|
	  pages.resources node_name
	end
      end

      #   map.welcome 'path_to_admin_login', :controller => :admin, :action => :welcome
      def jjane_admin(path_to_admin_login='admin')
	welcome path_to_admin_login, :controller => :login, :action => :welcome
      end

      # it is the same as 
      #   map.root :controller => :site, :action => :home_page
      def jjane_root
	root :controller => :site, :action => :home_page
      end

      def jjane_connect
	resources :pages, :except => [:show], :collection => { :sort => :put } do |page|
	  page.resources :child, :controller => :pages, :only => [:new]
	  #  page.resources :nodes,:except => [:index, :show]
	end
	resources :snippets, :except => [:show]
	resources :users
	login '__login__', { :controller => :login, :action => :login }
	logout '__logout__', { :controller => :login, :action => :logout }
	connect '*uri/:year/:month/:day', {
	  :controller => 'site',
	  :action     => 'find_by_day',
	  :year       => /\d{4}/,
	  :month      => /\d{1,2}/,
	  :day        => /\d{1,2}/
	}
	connect '*uri/:id', {
	  :controller => :site,
	  :action => :node,
	  :requirements => { :id => /\d+/ }
	}
	connect '*uri', {
	  :controller => :site,
	  :action => :page
	}
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, JJane::Routing::MapperExtensions
