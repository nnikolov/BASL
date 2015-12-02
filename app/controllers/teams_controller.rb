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
      format.xml  { render :xml => @teams.to_xml(:include => :players)}
      format.json  { render :json => @teams.to_json(:include => :players) }
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
    @team = Team.new(team_params)

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
      filename = sanitize_filename "teams_#{params[:id]}_#{params[:team][:photo].original_filename}"
      params[:team][:file_name] = filename
      params[:team][:content_type] = params[:team][:photo].content_type.chomp
      #params[:team][:file_data] = params[:team][:photo].read
      File.open( "#{Rails.root}/public/images/#{filename}".to_s, 'wb' ) do |file|
        file.write( params[:team][:photo].read )
      end
      params[:team].delete('photo')
    end

    photo = @team.photos.new(:file_name => filename, :caption => params[:team][:photo_caption])
    photo.save

    respond_to do |format|
      if @team.update_attributes(team_params)
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
    @team = Team.find(params[:team_id])
    #send_data(team.file_data, :filename => team.file_name, :type => team.content_type, :disposition => "inline")
  end

  def games
    @team = Team.find(params[:id])

    respond_to do |format|
      format.ics # index.ics.erb
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  def update_photo
    photo = Photo.find(params[:id])
    photo.update_attributes(params[:photo])
    redirect_to(season_team_path(photo.team.season_id, photo.team))
  end

  private

  def sanitize_filename(filename)
    # Split the name when finding a period which is preceded by some
    # character, and is followed by some character other than a period,
    # if there is no following period that is followed by something
    # other than a period (yeah, confusing, I know)
    #fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
    fn = filename.split(".")
  
    # We now have one or two parts (depending on whether we could find
    # a suitable period). For each of these parts, replace any unwanted
    # sequence of characters with an underscore
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
  
    # Finally, join the parts with a period and return the result
    return fn.join '.'
  end

  def team_params
    params.require(:team).permit(:id, :name, :color, :season_id, :pool_id, :active)
  end

end
