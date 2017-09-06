class StandingsController < ApplicationController
  layout "application"
  before_action :check_authentication
  before_action :set_season

  def index
    @season_standings = Standing.season(:season_id => @season.id)
    @playoff_standings = Standing.playoff(:season_id => @season.id)

    respond_to do |format|
      format.html # index.html.erb
      combined = {:season => @season_standings, :playoffs => @playoff_standings}
      format.xml  { render :xml => combined}
      format.json  { render :json => combined}
    end

  end

end
