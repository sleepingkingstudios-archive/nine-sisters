class UsersController < ApplicationController
  # POST /user
  def create
    @user = User.new(params[:user])
    
    if @user.save
      redirect_to :root
    else
      render :action => "new"
    end # if-else
  end # method create
  
  # GET /user/new
  def new
    @user = User.new
    if request.xhr?
      User.first.nil? ? render( :layout => false ) : redirect_to(new_session_path)
    else
      redirect_to(new_session_path) and return unless User.first.nil?
    end # if-else
  end # action new
end # controller Users
