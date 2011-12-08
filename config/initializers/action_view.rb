# config/initializers/action_view.rb

# Fix the annoying "<div class='field_with_errors'>...</div>" default behavior
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| html_tag }
