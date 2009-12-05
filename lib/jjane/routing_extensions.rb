module JJane#:nodoc:
  module Routing #:nodoc:
    module MapperExtensions
      def jjane_connect
	@set.add_route '*uri/:year/:month/:day', {
	  :controller => 'site',
	  :action     => 'find_by_day',
	  :year       => /\d{4}/,
	  :month      => /\d{1,2}/,
	  :day        => /\d{1,2}/
	}
	@set.add_route '*uri/:id', {
	  :controller => :site,
	  :action => :node,
	  :requirements => {:id => /\d+/}
	}
	@set.add_route '*uri', {
	  :controller => :site,
	  :action => :page
	}
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, JJane::Routing::MapperExtensions

=begin
ActionController::Routing::Routes.draw do |map|

  # root route
  map.root :controller => :site, :action => :home_page

  # routes for filesystem
  map.resources :attached_files do |m|
    m.resource :directory, :controller => :attached_files, :only => :new
    m.upload 'file/new', :controller => :attached_files, :action => :new_file
  end

#---------------------------------------ENGINE\/

  # resource-oriented routes
  map.resources :pages, :except => [:show], :collection => { :sort => :put } do |page|
    page.resources :child, :controller => :pages, :only => [:new]
    page.resources :nodes,:except => [:index, :show]
    page.resources :articles
  end
  map.resources :users, :snippets

  # named routes
  map.welcome 'admin', :controller => :admin, :action => :welcome
  map.login '__login__', :controller => :admin, :action => :login
  map.logout '__logout__', :controller => :admin, :action => :logout



end
=end
