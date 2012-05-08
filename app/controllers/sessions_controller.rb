class SessionsController < ApplicationController
  # POST /session
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      append_flash :notice, "You have successfully logged in as #{params[:email]}.", true
    else
      append_flash :error, "Unable to authenticate user #{params[:email]}", true
    end # if-else
    
    redirect_to :root
  end # action create
  
  # DELETE /session
  def destroy
    session[:user_id] = nil
    append_flash :notice, "You have successfully logged out.", true
    redirect_to :root
  end # action destroy
  
  # GET /session/new
  def new
    if request.xhr?
      render :layout => false
    else
      redirect_to :root
    end # if-else
  end # action new
end # controller Sessions
