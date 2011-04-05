  def update
    @<%= instance_name %> = <%= class_name %>.find(params[:id])
    if @<%= instance_name %>.update_attributes(params[:<%= instance_name %>])
      redirect_to(<%= instances_url %>, :notice => "<%= class_name %> #{@<%= instance_name %>.id} was successfully updated.")
    else
      render :action => "edit"
    end
  end
