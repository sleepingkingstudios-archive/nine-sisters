class Setting < ActiveRecord::Base
  class << self
    def [](key)
      (setting = self.find_by_key(key)) ? setting.value : nil
    end # method []
  end # class << self
  
  validates :key,   :presence => :true, :uniqueness => :true
  validates :value, :presence => :true
end # model Setting
