class FtfilesController < ApplicationController
  def index
    @ftfiles = Ftfile.find(:all)
  end
  
  def show
    @ftfile = Ftfile.find(params[:id])
  end
  
  def new
    @ftfile = Ftfile.new
  end
  
  def create
    @ftfile = Ftfile.new(params[:ftfile])
    if @ftfile.save
      flash[:notice] = "Successfully created ftfile."
      redirect_to @ftfile
    else
      render :action => 'new'
    end
  end
  
  def edit
    @ftfile = Ftfile.find(params[:id])
  end
  
  def update
    @ftfile = Ftfile.find(params[:id])
    if @ftfile.update_attributes(params[:ftfile])
      flash[:notice] = "Successfully updated ftfile."
      redirect_to @ftfile
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @ftfile = Ftfile.find(params[:id])
    @ftfile.destroy
    flash[:notice] = "Successfully destroyed ftfile."
    redirect_to ftfiles_url
  end
end
