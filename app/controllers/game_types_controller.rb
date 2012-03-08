class GameTypesController < ApplicationController
  # GET /game_types
  # GET /game_types.xml
  def index
    @game_types = GameType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_types }
    end
  end

  # GET /game_types/1
  # GET /game_types/1.xml
  def show
    @game_type = GameType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_type }
    end
  end

  # GET /game_types/new
  # GET /game_types/new.xml
  def new
    @game_type = GameType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_type }
    end
  end

  # GET /game_types/1/edit
  def edit
    @game_type = GameType.find(params[:id])
  end

  # POST /game_types
  # POST /game_types.xml
  def create
    @game_type = GameType.new(params[:game_type])

    respond_to do |format|
      if @game_type.save
        format.html { redirect_to(@game_type, :notice => 'Game type was successfully created.') }
        format.xml  { render :xml => @game_type, :status => :created, :location => @game_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_types/1
  # PUT /game_types/1.xml
  def update
    @game_type = GameType.find(params[:id])

    respond_to do |format|
      if @game_type.update_attributes(params[:game_type])
        format.html { redirect_to(@game_type, :notice => 'Game type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_types/1
  # DELETE /game_types/1.xml
  def destroy
    @game_type = GameType.find(params[:id])
    @game_type.destroy

    respond_to do |format|
      format.html { redirect_to(game_types_url) }
      format.xml  { head :ok }
    end
  end
end
