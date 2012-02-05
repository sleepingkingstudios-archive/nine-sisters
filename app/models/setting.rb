# app/models/setting.rb

class ValueByKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    case record.key
    when :navigation
      value.split(',').each do |nav_item|
        unless (tokens = nav_item.split('=')).length == 2
          record.errors[attribute] << "must be a label and a path, separated by an equals sign"
        end # unless
        label, path = tokens
        
        begin
          uri = URI.parse path
          
        rescue URI::InvalidURIError => error
          record.errors[attribute] << "path must be a valid URI"
        end # begin-rescue
      end # each
    end # case record.key
  end # method validate_each
end # validator ValueByKey

class Setting < ActiveRecord::Base
  # id:integer (primary key)
  # key:string
  # value:string
  # created_at:datetime
  # updated_at:datetime
  
  class << self
    def [](key)
      (@@settings ||= Hash.new)[key] || (setting = self.find_by_key(key)) ? setting.value : nil
    end # method []
  end # class << self
  
  after_save do |setting|
    (@@settings ||= Hash.new)[setting.key] = setting.value
  end # after_save
  
  validates :key,   :presence => :true, :uniqueness => :true
  validates :value, :value_by_key => :true
end # model Setting
