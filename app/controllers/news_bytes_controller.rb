class NewsBytesController < ApplicationController
  # GET /news_bytes
  # GET /news_bytes.xml
  def index
    @news_bytes = NewsByte.find(:all, :order => 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news_bytes }
    end
  end

  # GET /news_bytes/1
  # GET /news_bytes/1.xml
  def show
    @news_byte = NewsByte.find(params[:id])

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
    @news_byte = NewsByte.find(params[:id])
  end

  # POST /news_bytes
  # POST /news_bytes.xml
  def create
    @news_byte = NewsByte.new(params[:news_byte])

    respond_to do |format|
      if @news_byte.save
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
    @news_byte = NewsByte.find(params[:id])

    respond_to do |format|
      if @news_byte.update_attributes(params[:news_byte])
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
    @news_byte = NewsByte.find(params[:id])
    @news_byte.destroy

    respond_to do |format|
      format.html { redirect_to(news_bytes_url) }
      format.xml  { head :ok }
    end
  end
end
