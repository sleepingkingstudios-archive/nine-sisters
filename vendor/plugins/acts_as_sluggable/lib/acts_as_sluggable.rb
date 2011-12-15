# acts_as_sluggable/lib/acts_as_sluggable.rb

module ActsAsSluggable
  extend ActiveSupport::Concern
  
  ACCENTS_MAPPING = {
    'E' => [200,201,202,203],
    'e' => [232,233,234,235],
    'A' => [192,193,194,195,196,197],
    'a' => [224,225,226,227,228,229,230],
    'C' => [199],
    'c' => [231],
    'O' => [210,211,212,213,214,216],
    'o' => [242,243,244,245,246,248],
    'I' => [204,205,206,207],
    'i' => [236,237,238,239],
    'U' => [217,218,219,220],
    'u' => [249,250,251,252],
    'N' => [209],
    'n' => [241],
    'Y' => [221],
    'y' => [253,255],
    'AE' => [306],
    'ae' => [346],
    'OE' => [188],
    'oe' => [189]
  } # end constant ACCENTS_MAPPING
  
  included do
    # nothing
  end # included
  
  module ClassMethods
    def acts_as_sluggable(source_attr, options = {})
      configuration = {
        :__source_attr__ => source_attr,
        :column => :slug,
        :presence => true,
        :uniqueness => true
      } # end configuration
      configuration.update(options) if options.is_a? Hash
      
      cattr_accessor :__acts_as_sluggable_config__
      self.__acts_as_sluggable_config__ = configuration
      
      attr_protected configuration[:column]
      
      before_validation :__update_slug__
      
      validates configuration[:column], :presence => true if configuration[:presence]
      validates configuration[:column], :uniqueness => configuration[:uniqueness] if configuration[:uniqueness]
    end # class method acts_as_sluggable
    
    def __remove_accents__(str)
      ActsAsSluggable::ACCENTS_MAPPING.each do |letter, accents|
        packed = accents.pack('U*')
        rxp = Regexp.new("[#{packed}]")
        str.gsub!(rxp, letter)
      end # each

      return str
    end # class method __remove_accents__
  end # module ClassMethods
  
  module InstanceMethods
    def __update_slug__
      __configuration__ = self.class.__acts_as_sluggable_config__
      __source_attr__  = __configuration__[:__source_attr__]
      __source_value__ = (self.send __source_attr__).to_s
      __target_attr__  = __configuration__[:column]
      __target_value__ = self.class.__remove_accents__(__source_value__.downcase.gsub(/\s+/, '-'))

      # puts "\n\n#{self} update_slug(): source_attr = \"#{__source_attr__}\", source_value = \"#{__source_value__}\", target_attr = \"#{__target_attr__}\", target_value = \"#{__target_value__}\"\n\n"
      self.send "#{__target_attr__}=".intern, __target_value__
    end # method __update_slug__
  end # module InstanceMethods
end # module ActsAsSluggable

ActiveRecord::Base.send :include, ActsAsSluggable