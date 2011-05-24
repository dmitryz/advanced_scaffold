class <%= plural_camelize_controller_name %>Controller < <%= camelize_master_name %>Controller
  require 'advanced_scaffold/keep_params_in_session/keep_params_in_session'
  include KeepParamsInSession
  helper_method :sort_column, :sort_direction
  <%= controller_methods :actions %>
private
  def sort_column
    <%= class_name %>.column_names.include?(params[:sort]) ? params[:sort] : "<%= model_attributes.first.name %>"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
