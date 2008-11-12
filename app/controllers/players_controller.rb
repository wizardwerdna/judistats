

class PlayersController < ApplicationController
  def index
    @players = Player.paginate :page => params[:page], :per_page => 10,
                                :conditions => ['screen_name like ?', "%#{params[:search]}%"],
                                :order => 'screen_name'
  end
  
  def show
    @player = Player.find(params[:id])
  end
  
  def new
    @player = Player.new
  end
  
  def create
    @player = Player.new(params[:player])
    if @player.save
      flash[:notice] = "Successfully created player."
      redirect_to @player
    else
      render :action => 'new'
    end
  end
  
  def edit
    @player = Player.find(params[:id])
  end
  
  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(params[:player])
      flash[:notice] = "Successfully updated player."
      redirect_to @player
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @player = Player.find(params[:id])
    @player.destroy
    flash[:notice] = "Successfully destroyed player."
    redirect_to players_url
  end
end
