class SeasonsController < ApplicationController
  before_action :set_season, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization, :except => ['index', 'redirect']

  # GET /seasons
  # GET /seasons.xml
  def index
    if @logged_in
      @seasons = Season.order('start_date desc')
    else
      @seasons = Season.where("active = ? or current = ?", true, true).order('start_date desc')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seasons }
    end
  end

  # GET /seasons/1
  # GET /seasons/1.xml
  def show
    #@season = Season.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/new
  # GET /seasons/new.xml
  def new
    @season = Season.new
    @seasons = Season.order('start_date desc')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/1/edit
  def edit
    #@season = Season.find(params[:id])
  end

  # POST /seasons
  # POST /seasons.xml
  def create
    @season = Season.new(season_params)

    respond_to do |format|
      if @season.save
        @season.model_after(params[:model_after])
        format.html { redirect_to(@season, :notice => 'Season was successfully created.') }
        format.xml  { render :xml => @season, :status => :created, :location => @season }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /seasons/1
  # PUT /seasons/1.xml
  def update
    #@season = Season.find(params[:id])

    respond_to do |format|
      #if @season.update_attributes(params[:season])
      if @season.update_attributes(season_params)
        format.html { redirect_to(@season, :notice => 'Season was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.xml
  def destroy
    #@season = Season.find(params[:id])
    @season.destroy

    respond_to do |format|
      format.html { redirect_to(seasons_url) }
      format.xml  { head :ok }
    end
  end

  def redirect
    case params[:last_controller]
    when 'games'
      redirect_to season_games_path(params[:season][:id].to_i)
    when 'teams'
      redirect_to season_teams_path(params[:season][:id].to_i)
    when 'standings'
      redirect_to season_standings_path(params[:season][:id].to_i)
    when 'rankings'
      redirect_to season_rankings_path(params[:season][:id].to_i)
    else
      redirect_to root_path
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_season
    @season = Season.find(params[:id])
    unless @logged_in.update_site?
      @season.readonly!
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def season_params
    params.require(:season).permit(:id, :name, :current, :active, :start_date, :game_duration)
  end
end
