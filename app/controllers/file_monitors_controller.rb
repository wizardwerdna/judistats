class FileMonitorsController < ApplicationController
  def index
    @file_monitors = FileMonitor.find(:all)
  end
  
  def show
    @file_monitor = FileMonitor.find(params[:id])
  end
  
  def new
    @file_monitor = FileMonitor.new
  end
  
  def create
    @file_monitor = FileMonitor.new(params[:file_monitor])
    if @file_monitor.save
      flash[:notice] = "Successfully created filemonitor."
      redirect_to @file_monitor
    else
      render :action => 'new'
    end
  end
  
  def edit
    @file_monitor = FileMonitor.find(params[:id])
  end
  
  def update
    FileMonitor.start
    flash[:notice] = "Attempted to restart all file monitors.  Monitors take a while to start up, so refresh this page a few times before trying again."
    redirect_to file_monitors_url
  end
  
  def destroy
    FileMonitor.stop
    flash[:notice] = "Attempted to shut down all file monitors"
    redirect_to file_monitors_url
  end
end
