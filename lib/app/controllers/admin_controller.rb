class AdminController < ApplicationController #:nodoc:

  before_filter :check_access, :except => [:welcome, :login, :logout]
  before_filter :check_session, :only => [:login]

  def welcome
    error_404 if logged_in?
  end

  def login
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:login_notice] = "Successfully logged in."
      redirect_to root_url
    else
      flash[:login_error] = "Invalid login or/and password"
      render :action => 'welcome'
    end
  end

  def logout
    if current_user_session then
      @user_session = UserSession.find(params[:id])
      @user_session.destroy
      flash[:login_notice] = "Successfully logged out."
      redirect_to root_url
    else
      error_404
    end
  end

  def restart
    log `whoami`
    `touch tmp/restart.txt`
    if $?.exitstatus==0 then
      flash[:notice]="Web server succsessfully restarted"
    else
      flash[:error]="ERROR::File #{RAILS_ROOT}/tmp/restart.txt must be writable by web server\'s user"
    end
    redirect_to :action => :welcome
  end

  private

  def check_session
    error_404 if current_user_session
  end
end
