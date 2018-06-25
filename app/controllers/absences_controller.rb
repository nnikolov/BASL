class AbsencesController < ApplicationController
  before_action :set_absence, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization

  # GET /absences
  def index
    @absences = Absence.where(["game_date >= ?", Date.today]).sort
  end

  # GET /absences/1
  def show
  end

  # GET /absences/new
  def new
    @absence = Absence.new(game_date: Game.next_games[0].time)
  end

  # GET /absences/1/edit
  def edit
  end

  # POST /absences
  def create
    #@absence = Absence.new(absence_params)

    #if @logged_in.active and @logged_in.website and @absence.save
    if @logged_in.active and Absence.create_multiple(absence_params)
      #redirect_to @absence, notice: 'Absence was successfully created.'
      redirect_to absences_path, notice: 'Absence was successfully created.'
    else
      #render :new
      redirect_to absences_path, notice: 'Absence was NOT successfully created.'
    end
  end

  # PATCH/PUT /absences/1
  def update
    if @logged_in.active and @logged_in.website and @absence.update(absence_params)
      redirect_to @absence, notice: 'Absence was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /absences/1
  def destroy
    if @logged_in.active and @logged_in.website
      @absence.destroy
      redirect_to absences_url, notice: 'Absence was successfully destroyed.'
      return
    end
    redirect_to absences_url, notice: 'Absence was NOT destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_absence
      @absence = Absence.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def absence_params
      params.require(:absence).permit({player_id: []}, :game_date)
    end
end
