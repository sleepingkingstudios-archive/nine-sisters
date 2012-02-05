class Admin::SettingsController < ApplicationController
  before_filter :authenticate_user
  
  # GET /admin/settings
  def index
    @settings = Setting.all
  end # action index
  
  # POST /admin/settings
  def create
    logger.debug "params = #{params.inspect}"
    if params[:settings]
      # sort out navigation settings
      params[:settings][:navigation] = params[:settings][:navigation].map{ |item|
        next if item[:label].empty? || item[:path].empty?
        "#{item[:label]}=#{item[:path]}"
      }.join(',')
      
      params[:settings].each do |key, value|
        setting = Setting.find_by_key(key) || Setting.new(:key => key)
        unless setting.value == value
          setting.value = value
          
          if setting.save
            append_flash(:notice, "#{key.capitalize} has been updated", true)
          else
            setting.errors[:value].each do |message|
              append_flash :error, "#{key.capitalize} #{message}", true
            end # each
          end # if-else
        end # unless
      end # each
    else
      append_flash :error, "Server did not receive settings parameters"
    end # if-else
    
    redirect_to admin_settings_path
  end # action create
end # controller SettingsController
