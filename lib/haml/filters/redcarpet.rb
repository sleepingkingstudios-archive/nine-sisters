# lib/haml/filters/redcarpet.rb

require 'redcarpet'

module Haml::Filters::Redcarpet
  include Haml::Filters::Base
  
  def render(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    
    return "<div class='redcarpet'>" + markdown.render(text) + "</div>"
  end # method render
end # module Haml::Filters::Redcarpet
