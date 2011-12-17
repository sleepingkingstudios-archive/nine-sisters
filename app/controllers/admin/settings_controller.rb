class Admin::SettingsController < ApplicationController
  before_filter :authenticate_user
  
  # GET /admin/settings
  def index
    @settings = Setting.all
  end # action index
  
  # POST /admin/settings
  def create
    logger.debug "params = #{params.inspect}"
    params[:settings] ||= []
    params[:settings].each do |key, value|
      setting = Setting.find_by_key(key) || Setting.new(:key => key)
      setting.value = value
      
      unless setting.save
        setting.errors[:value].each do |message|
          append_flash :error, "#{key.capitalize} #{message}", true
        end # each
      end # unless
    end # each
    
    redirect_to admin_settings_path
  end # action create
end # controller SettingsController
