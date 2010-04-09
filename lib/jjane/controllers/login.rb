class LoginController < ApplicationController

  before_filter :check_session, :only => [:login]

  def welcome
    error_404 if logged_in?
  end

  def error(redirect_place = :root_url)#TODO redirect # for title 'Login::Error'
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:login_notice] = t(:notice_logged_in)
      redirect_to method(redirect_place).call
    else
      flash[:login_error] = t(:notice_invalid_login_or_password)
      render :action => 'welcome'
    end
  end

  def logout(redirect_place = :root_url)#TODO redirect
    if current_user_session then
      @user_session = UserSession.find(params[:id])
      @user_session.destroy
      flash[:login_notice] = t(:notice_logged_out)
      redirect_to method(redirect_place).call
    else
      error_404
    end
  end

  private

  def check_session
    error_404 if current_user_session
  end
end
