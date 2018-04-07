class RankingsController < ApplicationController
  before_action :check_authorization
  before_action :set_ranking, only: [:show, :update, :destroy]

  # GET /rankings
  @rankings = Ranking.all
  def index
    if @logged_in.website or @logged_in.admin
      @players = @season.players.sort
    else
      @players = []
    end
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

    #if @ranking.save
    #  redirect_to new_ranking_path, notice: 'Ranking was successfully created.'
    #else
    #  render :new
    #end

    respond_to do |format|
      if @ranking.save
        format.js { render action: 'update' }
        format.html { redirect_to new_ranking_path, notice: 'Ranking was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /rankings/1
  def update
    #if @ranking.update(ranking_params)
    #  redirect_to new_ranking_path, notice: 'Ranking was successfully updated.'
    #else
    #  render :edit
    #end
    respond_to do |format|
      if @ranking.update(ranking_params)
        format.js { render action: 'update' }
        #format.html { redirect_to lot_path(@lot), notice: 'Lot was successfully updated.' }
        format.html { redirect_to new_ranking_path, notice: 'Ranking was successfully updated.' }
        format.json { head :no_content }
      else
        format.js { render action: 'error' }
        format.html { render action: 'edit' }
        format.json { render json: @lot.errors, status: :unprocessable_entity }
      end
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
