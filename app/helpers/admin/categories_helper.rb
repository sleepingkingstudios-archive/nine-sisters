module Admin::CategoriesHelper
  def category_actions(category, params = {})
    config = { :except => nil, :only => nil, :separator => " | " }
    config.update(params) if params.is_a? Hash
    %w(except only).each{ |key|
      config[key.intern] = config[key.intern].nil? ? nil : [config[key.intern]].flatten
    } # each
    
    logger.debug "Category Actions, config = #{config.inspect}"
    
    self.define_singleton_method :visible?, lambda { |item|
      vis = (config[:except].nil? || !config[:except].include?(item)) &&
        (config[:only].nil? || config[:only].include?(item))
      logger.debug "Visible, config = #{config.inspect}, item = #{item}, visible = #{vis.inspect}"
      return vis
    } # end visible_block
    
    items = Array.new
    
    items << (link_to "Show Category", admin_category_path(category)) if visible?(:show)
    items << (link_to "Edit Category", edit_admin_category_path(category)) if visible? :edit
    
    if visible? :delete
      delete  = link_to "Delete Category", nil, :class => [:"delete-link", :"red-text"]
      delete += "<span class='hidden-link'>".html_safe
      delete += link_to nil, admin_category_path(category), :method => :delete
      delete += "</span>".html_safe
      items << delete
    end # if
    
    return items.join(config[:separator]).html_safe
  end # helper category_actions
  private :category_actions
  
  def nested_category_list_item(category)
    str = "<li>#{link_to category.title, [:admin, category]}"
    if category.children.count > 0
      str += "<ul>" + category.children.map { |child| nested_category_list_item(child) }.join + "</ul>"
    end # if
    
    str += "</li>"
    return str.html_safe
  end # method nested_category_list_item
end # helper CategoriesHelper
