class RegistrationLandingPagesController < ApplicationController
  before_action :set_registration_landing_page, only: [:show, :edit, :update, :destroy]

  # GET /registration_landing_pages
  def index
    @registration_landing_pages = RegistrationLandingPage.all
  end

  # GET /registration_landing_pages/1
  def show
  end

  # GET /registration_landing_pages/new
  def new
    @registration_landing_page = RegistrationLandingPage.new
  end

  # GET /registration_landing_pages/1/edit
  def edit
  end

  # POST /registration_landing_pages
  def create
    @registration_landing_page = RegistrationLandingPage.new(registration_landing_page_params)

    if @registration_landing_page.save
      redirect_to @registration_landing_page, notice: 'Registration landing page was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /registration_landing_pages/1
  def update
    if @registration_landing_page.update(registration_landing_page_params)
      redirect_to @registration_landing_page, notice: 'Registration landing page was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /registration_landing_pages/1
  def destroy
    @registration_landing_page.destroy
    redirect_to registration_landing_pages_url, notice: 'Registration landing page was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_landing_page
      @registration_landing_page = RegistrationLandingPage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def registration_landing_page_params
      params.require(:registration_landing_page).permit(:name, :description, :active)
    end
end
