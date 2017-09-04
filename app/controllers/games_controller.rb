class GamesController < ApplicationController
  before_action :set_game, only: [:cancel_edit, :gamesheet, :show, :edit, :update, :destroy]
  before_filter :check_authorization, :except => ['index', 'gamesheet', 'next_games']


  def next_games
    @games = Game.next_games
  end

  # GET /games/1/home/gamesheet
  def gamesheet
    #@game = Game.find(params[:id])
    if params[:team] == 'home'
      @team = @game.home_team
    else
      @team = @game.away_team
    end
    render :layout => false
  end

  # POST /games/1/update_game_duration
  def update_game_duration
    season = Season.find(params[:id])
    season.update_attributes(:game_duration => params[:game_duration])
    redirect_to season_games_path(season)
  end

  # GET /games
  # GET /games.xml
  def index
    @games = @season.games #Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    #@game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new
    @game.season_id = params[:season_id]
    @game.time = Time.now - Time.now.strftime("%M").to_i.minutes
    @teams = Team.where(season_id: @game.season_id).order(:name)
    @game_types = GameType.all

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    #@game = Game.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def cancel_edit
    #@game = Game.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def cancel_new
    respond_to do |format|
      format.js
    end
  end

  # POST /games
  # POST /games.xml
  def create
    #@game = Game.new(params[:game])
    @game = Game.new(game_params)
    @game.season_id = params[:season_id]
    @games = Game.where(:season_id => @game.season_id)

    respond_to do |format|
      if @logged_in.update_site? and @game.save
        format.html { redirect_to(season_game_path(@game.season_id, @game), :notice => 'Game was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    #@game = Game.find(params[:id])

    respond_to do |format|
      #if @game.update_attributes(params[:game])
      if @game.update_attributes(game_params)
        format.html { redirect_to(season_game_path(@game.season_id, @game), :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    #@game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(season_games_path(params[:season_id])) }
      format.xml  { head :ok }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
    unless @logged_in and @logged_in.update_site?
      @game.readonly!
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_params
    params.require(:game).permit(:id, :season_id, :time, :field_id, :home_team_id, :home_team_score, :away_team_id, :away_team_score, :game_type_id, :until)
  end
end
