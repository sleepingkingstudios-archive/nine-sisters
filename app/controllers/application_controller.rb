class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def append_flash(key, message, persist = false)
    logger.info "append_flash(): key = #{key}, message = #{message}, persist = #{persist}"
    ((persist ? flash : flash.now)[key] ||= Array.new) << message
  end # method append_flash
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end # method current_user
  helper_method :current_user
  
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
  helper_method :mobile?
end # controller ApplicationController
