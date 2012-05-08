# lib/sass/functions/themes.rb

module Sass::Script::Functions
  class ThemeSet
    def initialize
      @themes = Hash.new
      @themes[:default] = Hash.new
    end # method initialize
    
    def get(theme, key)
      theme, key = theme.intern, key.intern
      if @themes.hasKey(theme) && (hsh = @themes[theme]).hasKey(key)
        return hsh[key]
      else
        return @themes[:default][key]
      end # if-else
    end # method get
  end # class ThemeSet
  
  @@theme_set = ThemeSet.new
  
  def get_theme(theme, key)
    return Sass::Script::Literal.new @@theme_set.get(theme.value, key.value)
  end # method get_theme
  declare :get_theme, :args => [:theme, :key]
end # module Sass::Script::Functions

