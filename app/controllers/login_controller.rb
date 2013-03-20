class LoginController < ApplicationController
  layout "application"

  def index
    #render :layout => false
  end

  def authenticate
    if @logged_in = User.authenticate(params[:user])
      session[:login] = params[:user]
      redirect_to :admin
    else
      flash[:notice] = 'Invalid username or password'
      render :action => 'index', :layout => false
    end
  end

  def logout
    session[:login] = nil
    #redirect_to :action => 'index'
    redirect_to :root
  end
end
