  def create
    @<%= instance_name %> = <%= class_name %>.new(params[:<%= instance_name %>])
    if @<%= instance_name %>.save
      redirect_to(<%= controller_instances_url %>, :notice => '<%= class_name %> was successfully created.')
    else
      render :action => "new"
    end
  end
