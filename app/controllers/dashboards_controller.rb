class DashboardsController < ApplicationController
  def index
    @hands = Hand.recent(5)
  end
  
  def show
    @dashboard = Dashboard.find(params[:id])
  end
  
  def new
    @dashboard = Dashboard.new
  end
  
  def create
    @dashboard = Dashboard.new(params[:dashboard])
    if @dashboard.save
      flash[:notice] = "Successfully created dashboard."
      redirect_to @dashboard
    else
      render :action => 'new'
    end
  end
  
  def edit
    @dashboard = Dashboard.find(params[:id])
  end
  
  def update
    @dashboard = Dashboard.find(params[:id])
    if @dashboard.update_attributes(params[:dashboard])
      flash[:notice] = "Successfully updated dashboard."
      redirect_to @dashboard
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @dashboard = Dashboard.find(params[:id])
    @dashboard.destroy
    flash[:notice] = "Successfully destroyed dashboard."
    redirect_to dashboards_url
  end
end
