module Admin::ArticlesHelper
  def article_status(article)
    if article.published?
      "Published"
    elsif article.draft?
      "Draft"
    else
      "Draft"
    end # if-elsif-else
  end # article_status
  private :article_status
  
  def article_actions(article, params = {})
    config = { :except => nil, :only => nil, :separator => " | " }
    config.update(params) if params.is_a? Hash
    %w(except only).each{ |key|
      config[key.intern] = config[key.intern].nil? ? nil : [config[key.intern]].flatten
    } # each
    
    logger.debug "Article Actions, config = #{config.inspect}"
    
    self.define_singleton_method :visible?, lambda { |item|
      vis = (config[:except].nil? || !config[:except].include?(item)) &&
        (config[:only].nil? || config[:only].include?(item))
      logger.debug "Visible, config = #{config.inspect}, item = #{item}, visible = #{vis.inspect}"
      return vis
    } # end visible_block
    
    items = Array.new
    
    items << (link_to "Show Article", admin_article_path(article)) if visible?(:show)
    items << (link_to "Edit Article", edit_admin_article_path(article)) if visible? :edit

    if visible?(:publish) && article.draft?
      items << (link_to "Publish Article", publish_admin_article_path(article), :method => :post)
    elsif visible? :revert
      items << (link_to "Revert Article", revert_admin_article_path(article), :method => :post)
    end # if-elsif
    
    items << (link_to "Review Versions", nil) if visible? :versions
    
    if visible? :delete
      delete  = link_to "Delete Article", nil, :class => [:"delete-link", :"red-text"]
      delete += "<span class='hidden-link'>".html_safe
      delete += link_to nil, admin_article_path(article), :method => :delete
      delete += "</span>".html_safe
      items << delete
    end # if
    
    return items.join(config[:separator]).html_safe
  end # helper article_actions
  private :article_actions
end # module Admin::ArticlesHelper
