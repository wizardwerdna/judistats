class SummariesController < ApplicationController
  def index
    @summaries = Summary.find(:all)
  end
  
  def show
    @summary = Summary.find(params[:id])
  end
  
  def new
    @summary = Summary.new
  end
  
  def create
    @summary = Summary.new(params[:summary])
    if @summary.save
      flash[:notice] = "Successfully created summary."
      redirect_to @summary
    else
      render :action => 'new'
    end
  end
  
  def edit
    @summary = Summary.find(params[:id])
  end
  
  def update
    @summary = Summary.find(params[:id])
    if @summary.update_attributes(params[:summary])
      flash[:notice] = "Successfully updated summary."
      redirect_to @summary
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @summary = Summary.find(params[:id])
    @summary.destroy
    flash[:notice] = "Successfully destroyed summary."
    redirect_to summaries_url
  end
end
