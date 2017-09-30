class NewsBytesController < ApplicationController
  before_action :set_news_byte, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization, :except => 'index'

  # GET /news_bytes
  # GET /news_bytes.xml
  def index
    @limit = params[:limit] ? params[:limit].to_i : 5
    offset = params[:offset].to_i
    @news_bytes = NewsByte.order("updated_at DESC").limit(@limit).offset(offset)
    @offset = @news_bytes.size == @limit ? @limit + offset : 0

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news_bytes }
      format.js   # index.js.erb
    end
  end

  # GET /news_bytes/1
  # GET /news_bytes/1.xml
  def show
    #@news_byte = NewsByte.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news_byte }
    end
  end

  # GET /news_bytes/new
  # GET /news_bytes/new.xml
  def new
    @news_byte = NewsByte.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news_byte }
    end
  end

  # GET /news_bytes/1/edit
  def edit
    #@news_byte = NewsByte.find(params[:id])
  end

  # POST /news_bytes
  # POST /news_bytes.xml
  def create
    #@news_byte = NewsByte.new(params[:news_byte])
    @news_byte = NewsByte.new(news_byte_params)

    respond_to do |format|
      if @logged_in.update_site? and @news_byte.save
        format.html { redirect_to(@news_byte, :notice => 'News byte was successfully created.') }
        format.xml  { render :xml => @news_byte, :status => :created, :location => @news_byte }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @news_byte.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /news_bytes/1
  # PUT /news_bytes/1.xml
  def update
    #@news_byte = NewsByte.find(params[:id])

    respond_to do |format|
      #if @news_byte.update_attributes(params[:news_byte])
      if @logged_in.active and @logged_in.website and @news_byte.update_attributes(news_byte_params)
        format.html { redirect_to(@news_byte, :notice => 'News byte was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news_byte.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /news_bytes/1
  # DELETE /news_bytes/1.xml
  def destroy
    #@news_byte = NewsByte.find(params[:id])
    if @logged_in.active and @logged_in.website
      @news_byte.destroy
    end

    respond_to do |format|
      format.html { redirect_to(news_bytes_url) }
      format.xml  { head :ok }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_news_byte
    @news_byte = NewsByte.find(params[:id])
    unless @logged_in.update_site?
      @news_byte.readonly!
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_byte_params
    params.require(:news_byte).permit(:id, :title, :body)
  end
end
