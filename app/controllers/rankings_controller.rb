class RankingsController < ApplicationController
  before_action :check_authorization
  before_action :set_ranking, only: [:show, :update, :destroy]

  # GET /rankings
  def index
    @rankings = Ranking.all
  end

  # GET /rankings/1
  def show
  end

  # GET /rankings/new
  def new
    #@ranking = Ranking.new
  end

  # GET /rankings/1/edit
  def edit
    @season
  end

  # POST /rankings
  def create
    @ranking = Ranking.new(ranking_params)

    if @ranking.save
      redirect_to new_ranking_path, notice: 'Ranking was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /rankings/1
  def update
    if @ranking.update(ranking_params)
      redirect_to new_ranking_path, notice: 'Ranking was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /rankings/1
  def destroy
    @ranking.destroy
    redirect_to rankings_url, notice: 'Ranking was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ranking
      @ranking = Ranking.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ranking_params
      params.require(:ranking).permit(:player_id, :user_id, :rank, :votes)
    end
end
