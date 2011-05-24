  def update
    @<%= instance_name %> = <%= class_name %>.find(params[:id])
    if @<%= instance_name %>.update_attributes(params[:<%= instance_name %>])
      redirect_to(<%= controller_instances_url %>, :notice => "<%= class_name %> #{@<%= instance_name %>.id} was successfully updated.")
    else
      render :action => "edit"
    end
  end
