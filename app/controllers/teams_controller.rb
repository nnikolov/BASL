class TeamsController < ApplicationController
  before_filter :check_authorization, :except => ['index', 'games', 'photo']

  # GET /teams
  # GET /teams.xml
  def index
    if @logged_in
      @teams = @season.teams #Team.all
    else
      @teams = Team.where(:active => true, :season_id => @season.id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])
    if @team.pool.blank?
      @pool_name = 'N/A'
    else
      @pool_name = @team.pool.name
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new
    @team.season_id = params[:season_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html { redirect_to(season_team_path(@team.season_id, @team), :notice => 'Team was successfully created.') }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])
    if params[:team][:photo] && !params[:team][:photo].blank? then
      params[:team][:file_name] = params[:team][:photo].original_filename
      params[:team][:content_type] = params[:team][:photo].content_type.chomp
      params[:team][:file_data] = params[:team][:photo].read
      File.open( "app/assets/images/#{params[:team][:photo].original_filename}".to_s, 'w' ) do |file|
        file.write( params[:team][:file_data] )
      end
      params[:team].delete('photo')
    end

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to(season_team_path(@team.season, @team), :notice => 'Team was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(season_teams_path(params[:season_id])) }
      format.xml  { head :ok }
    end
  end

  def photo
    team = Team.find(params[:team_id])
    send_data(team.file_data, :filename => team.file_name, :type => team.content_type, :disposition => "inline")
  end

  def games
    @team = Team.find(params[:id])

    respond_to do |format|
      format.ics # index.ics.erb
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end
end
