class FieldsController < ApplicationController
  before_action :set_field, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization, :except => ['index', 'show']

  # GET /fields
  # GET /fields.xml
  def index
    @fields = Field.order('name')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fields }
    end
  end

  # GET /fields/1
  # GET /fields/1.xml
  def show
    #@field = Field.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @field }
    end
  end

  # GET /fields/new
  # GET /fields/new.xml
  def new
    @field = Field.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @field }
    end
  end

  # GET /fields/1/edit
  def edit
    #@field = Field.find(params[:id])
  end

  # POST /fields
  # POST /fields.xml
  def create
    @field = Field.new(field_params)

    respond_to do |format|
      if @logged_in.update_site and @field.save
        format.html { redirect_to(@field, :notice => 'Field was successfully created.') }
        format.xml  { render :xml => @field, :status => :created, :location => @field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fields/1
  # PUT /fields/1.xml
  def update
    #@field = Field.find(params[:id])

    respond_to do |format|
      if @field.update_attributes(field_params)
        format.html { redirect_to(@field, :notice => 'Field was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fields/1
  # DELETE /fields/1.xml
  def destroy
    #@field = Field.find(params[:id])
    @field.destroy

    respond_to do |format|
      format.html { redirect_to(fields_url) }
      format.xml  { head :ok }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @field = Field.find(params[:id])
    unless @logged_in.update_site?
      @field.readonly!
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def field_params
    params.require(:field).permit(:id, :name, :code, :map_url, :location)
  end

end
