class SessionsController < ApplicationController
  before_filter :login_required,  :only => :destroy
  before_filter :redirect_if_logged_in, :only => [ :new, :create, :forgot_password ]
  before_filter :build_user_session,  :only => [ :new, :create ]
  
  def create
    if @session_user.save
      login(@session_user)
      flash[:notice] = "Welcome, you are now logged in."
      redirect_to user_path(current_user)
    else
      flash[:error] = 'Login failed. Did you mistype?'
      render :action => :new
    end
  end
  
  def destroy
    logout
    redirect_to root_path
  end
  
private
  def build_user_session
    @session_user = SessionUser.new(params[:session_user])
  end
  
  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
  
  def login_required
    redirect_to login_path unless logged_in?
  end
end
