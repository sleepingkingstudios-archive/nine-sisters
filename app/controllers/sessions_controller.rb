class SessionsController < ApplicationController
  # POST /session
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url
    else
      render :action => "new"
    end # if-else
  end # action create
  
  # DELETE /session
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end # action destroy
  
  # GET /session/new
  def new
    render :layout => !request.xhr?
  end # action new
end # controller Sessions
