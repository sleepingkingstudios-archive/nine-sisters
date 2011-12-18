module Admin::CategoriesHelper
  def nested_category_list_item(category)
    str = "<li>#{link_to category.title, [:admin, category]}"
    if category.children.count > 0
      str += "<ul>" + category.children.map { |child| nested_category_list_item(child) }.join + "</ul>"
    end # if
    
    str += "</li>"
    return str.html_safe
  end # method nested_category_list_item
end # helper CategoriesHelper
