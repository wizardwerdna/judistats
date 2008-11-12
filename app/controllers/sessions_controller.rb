class SessionsController < ApplicationController
  def index
    @sessions = Session.paginate :page => params[:page], :per_page => 10
  end
  
  def show
    @session = Session.find(params[:id])
  end
  
  def new
    @session = Session.new
  end
  
  def create
    @session = Session.new(params[:session])
    if @session.save
      flash[:notice] = "Successfully created session."
      redirect_to @session
    else
      render :action => 'new'
    end
  end
  
  def edit
    @session = Session.find(params[:id])
  end
  
  def update
    @session = Session.find(params[:id])
    if @session.update_attributes(params[:session])
      flash[:notice] = "Successfully updated session."
      redirect_to @session
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @session = Session.find(params[:id])
    @session.destroy
    flash[:notice] = "Successfully destroyed session."
    redirect_to sessions_url
  end
end
