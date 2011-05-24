  def destroy
    @<%= instance_name %> = <%= class_name %>.find(params[:id])
    @<%= instance_name %>.destroy
    redirect_to(<%= controller_instances_url %>, :notice => 'Successfully deleted')
  end
