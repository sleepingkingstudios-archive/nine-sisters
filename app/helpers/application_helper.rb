module ApplicationHelper
  def navigation_items(params = {})
    config = {
      :data => Setting[:navigation].split(","),
      :class => nil,
      :wrapper => nil,
      :ordered => false
    } # end config
    config.update(params) { |key, old_value, new_value|
      (old_value.is_a?(Hash) and new_value.is_a?(Hash)) ? old_value.update(new_value) : new_value
    } if params.is_a?(Hash)
    
    str = ""
    config[:data].each_with_index do |item_data, index|
      def yield_item(item_data, config = {})
        tokens = item_data.split('=')
        link_to tokens.first, tokens.last, :class => config[:class]
      end # function yield_item
      
      def yield_wrapper_tag(wrapper_data, config = {})
        wrapper_data = wrapper_data.clone
        if config[:ordered]
          wrapper_data[:class] = wrapper_data[:class] ? "#{wrapper_data[:class]} " : ""
          wrapper_data[:class] += "#{config[:data].count.even? ? 'even' : 'odd'}-#{wrapper_data[:index]}"
        end # if
        
        str = "<#{wrapper_data[:tag] || "span"}"
        wrapper_data.each do |key, value|
          str += " #{key}='#{value}'" unless %w(index tag).include? key.to_s
        end # each
        str += '>'
      end # yield_wrapper_tag
      
      case
      when config[:wrapper].is_a?(Hash)
        str += yield_wrapper_tag(config[:wrapper].update({:index => index}), config)
        str += yield_item(item_data, config)
        str += "</#{config[:wrapper][:tag]}>"
      else
        str += yield_item(item_data, config)
      end # case
    end # each
    
    str.html_safe
  end # helper navigation_items
  private :navigation_items
  
  def lighten(text)
    "<span class='light'>#{text}</span>".html_safe
  end # helper lighten
  private :lighten
  
  def ascii_escape(string)
    output = ""
    (0..(string.length - 1)).each do |index|
      output << "&##{string[index].ord};"
    end # each
    output.html_safe
  end # helper ascii_escape
  
  def preview(string, charlimit = 300)
    return string if (charlimit == nil) || (charlimit <= 0)
    output = ""
    string.split(/\s+/).each do |substr|
      (1 + output.length + substr.length) <= charlimit ?
        output += " " + substr :
        break
    end # each
    return output.html_safe
  end # method preview
end # module ApplicationHelper
