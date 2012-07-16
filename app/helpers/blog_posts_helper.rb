module BlogPostsHelper
  def preview(string, charlimit = 300)
    return string if (charlimit == nil) || (charlimit <= 0)
    output = ""
    string.split(/\s+/).each do |substr|
      (1 + output.length + substr.length) <= charlimit ?
        output += " " + substr :
        break
    end # each
    
    output = Nokogiri::HTML.parse(output).css('body > *')
    last = output.last
    last.content += "..."
    
    return (output.to_html).html_safe
  end # method preview
end # end module BlogPostsHelper
