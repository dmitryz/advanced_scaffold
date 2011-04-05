module Sortable
  def sortable(column,  title=nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title,  params.merge(:sort => column, :direction => direction, :page => nil),
                    {:class => css_class, :remote => true}
  end
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end
  def show_title?
    @show_title
  end
  def show_change_password?(o)
    %{edit update}.include?(controller.action_name) && o.password.blank?  &&  o.password_confirmation.blank?
  end
end
