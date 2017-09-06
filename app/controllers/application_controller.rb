class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_season
  before_action :check_authentication
  before_action :mobile_device?

  def check_authentication
    #unless session[:login] and @logged_in = User.find_by_login(session[:login])
    #  redirect_to :controller => 'login', :action => 'index'
    #end
    if session[:login]
      @logged_in = User.find_by_login(session[:login])
    end
  end

  def check_authorization
    redirect_to login_path unless @logged_in
  end

  def set_season
    if params[:season_id]
      session[:season] = params[:season_id]
    end
    #if params[:season][:id]
    begin
      session[:season] = params[:season][:id]
    rescue
    end
    if session[:season]
      @season = Season.find(session[:season])
    else
      @season = Season.where(current: true).first
    end
    rescue
      @season = Season.where(current: true).first
  end

  def mobile_device?
    @mobile = request.user_agent =~ /Mobile|webOS/ ? true : false
  end
end
