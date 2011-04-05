  def index
    save_last_path
    params[:search] = "" if params[:remove_filter]
    keep_params_in_session('<%= instances_name %>_index', { :global =>  :page },
                                                          { :glboal => :direction},
                                                          { :global => :sort},
                                                          { :global => :search})

    @<%= instances_name %> = <%= class_name %>.search(params[:search]).order(sort_column + " " + sort_direction).pag(params[:page])
  end
