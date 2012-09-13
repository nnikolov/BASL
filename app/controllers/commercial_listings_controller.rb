class CommercialListingsController < ApplicationController
  before_filter :check_authorization, :except => 'index'

  # GET /commercial_listings
  # GET /commercial_listings.json
  def index
    @commercial_listings = CommercialListing.order(:player_name).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @commercial_listings }
      format.xml { render :xml => @commercial_listings }
    end
  end

  # GET /commercial_listings/1
  # GET /commercial_listings/1.json
  # GET /commercial_listings/1.vcard
  def show
    @commercial_listing = CommercialListing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @commercial_listing }
      format.vcard # show.vcard.erb
    end
  end

  # GET /commercial_listings/new
  # GET /commercial_listings/new.json
  def new
    @commercial_listing = CommercialListing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @commercial_listing }
    end
  end

  # GET /commercial_listings/1/edit
  def edit
    @commercial_listing = CommercialListing.find(params[:id])
  end

  # POST /commercial_listings
  # POST /commercial_listings.json
  def create
    @commercial_listing = CommercialListing.new(params[:commercial_listing])

    respond_to do |format|
      if @commercial_listing.save
        format.html { redirect_to @commercial_listing, :notice => 'Commercial listing was successfully created.' }
        format.json { render :json => @commercial_listing, :status => :created, :location => @commercial_listing }
      else
        format.html { render :action => "new" }
        format.json { render :json => @commercial_listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /commercial_listings/1
  # PUT /commercial_listings/1.json
  def update
    @commercial_listing = CommercialListing.find(params[:id])

    respond_to do |format|
      if @commercial_listing.update_attributes(params[:commercial_listing])
        format.html { redirect_to @commercial_listing, :notice => 'Commercial listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @commercial_listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /commercial_listings/1
  # DELETE /commercial_listings/1.json
  def destroy
    @commercial_listing = CommercialListing.find(params[:id])
    @commercial_listing.destroy

    respond_to do |format|
      format.html { redirect_to commercial_listings_url }
      format.json { head :no_content }
    end
  end
end
