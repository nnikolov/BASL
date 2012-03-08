class StandingsController < ApplicationController
  layout "application"
  before_filter :check_authentication
  before_filter :set_season

  def index
    @season_standings = Standing.season(:season_id => @season.id)
    @playoff_standings = Standing.playoff(:season_id => @season.id)
  end

end
