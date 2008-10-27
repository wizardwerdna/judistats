class HandsController < ApplicationController
  def index
    @hands = Hand.find(:all)
  end
  
  def show
    @hand = Hand.find(params[:id])
  end
  
  def new
    @hand = Hand.new
  end
  
  def create
    @hand = Hand.new(params[:hand])
    if @hand.save
      flash[:notice] = "Successfully created hand."
      redirect_to @hand
    else
      render :action => 'new'
    end
  end
  
  def edit
    @hand = Hand.find(params[:id])
  end
  
  def update
    @hand = Hand.find(params[:id])
    if @hand.update_attributes(params[:hand])
      flash[:notice] = "Successfully updated hand."
      redirect_to @hand
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @hand = Hand.find(params[:id])
    @hand.destroy
    flash[:notice] = "Successfully destroyed hand."
    redirect_to hands_url
  end
end
