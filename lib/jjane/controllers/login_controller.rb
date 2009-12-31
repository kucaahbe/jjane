class LoginController < ApplicationController

  before_filter :check_session, :only => [:login]

  def welcome
    error_404 if logged_in?
  end

  def login(redirect_place = :root_url)
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:login_notice] = "Successfully logged in."
      redirect_to method(redirect_place).call
    else
      flash[:login_error] = "Invalid login or/and password"
      render :action => 'welcome'
    end
  end

  def logout(redirect_place = :root_url)
    if current_user_session then
      @user_session = UserSession.find(params[:id])
      @user_session.destroy
      flash[:login_notice] = "Successfully logged out."
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
