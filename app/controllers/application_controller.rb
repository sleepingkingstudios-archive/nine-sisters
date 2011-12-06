class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter do
    @mobile_device = mobile?
  end # before_filter
  
  def mobile_agent?
    request.user_agent =~ /Mobile|webOS/
  end # method mobile_agent
  
  def mobile?
    case
    when !params[:mobile].nil?
      ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:mobile])
    when !session[:mobile].nil?
      !!session[:mobile]
    else
      mobile_agent?
    end # case
  end # method mobile?
end # controller ApplicationController
