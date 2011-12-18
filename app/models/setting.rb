class Setting < ActiveRecord::Base
  class << self
    def [](key)
      (@@settings ||= Hash.new)[key] || (setting = self.find_by_key(key)) ? setting.value : nil
    end # method []
  end # class << self
  
  after_save do |setting|
    (@@settings ||= Hash.new)[setting.key] = setting.value
  end # after_save
  
  validates :key,   :presence => :true, :uniqueness => :true
  validates :value, :presence => :true
end # model Setting
