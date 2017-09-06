class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization, :except => ['index', 'redirect']

  # GET /players
  # GET /players.xml
  def index
    @team = Team.find(params[:team_id])
    @players = @team.players

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    #@player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new
    @player.team_id = params[:team_id]
    @player.active = true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    #@player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @logged_in.update_site? and @player.multi_save
        format.html { redirect_to(team_players_path(@player.team_id), :notice => 'Player was successfully created.') }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    #@player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(player_params)
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    #@player = Player.find(params[:id])
    team_id = @player.team_id
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(team_players_url(team_id)) }
      format.xml  { head :ok }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find(params[:id])
    unless @logged_in.update_site?
      @player.readonly!
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def player_params
    params.require(:player).permit(:id, :name, :names, :team_id, :manager, :note, :position, :number, :active)
  end

end
