class SessionsController < ApplicationController
  # POST /session
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      append_flash :notice, "You have successfully logged in as #{params[:email]}.", true
      redirect_to "/index"
    else
      render :action => "new"
    end # if-else
  end # action create
  
  # DELETE /session
  def destroy
    session[:user_id] = nil
    append_flash :notice, "You have successfully logged out.", true
    redirect_to "/index"
  end # action destroy
  
  # GET /session/new
  def new
    render :layout => !request.xhr?
  end # action new
end # controller Sessions
