class RulesController < ApplicationController
  before_action :set_rule, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization, :except => 'index'

  # GET /rules
  # GET /rules.xml
  def index
    @rules = Rule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rules }
    end
  end

  # GET /rules/1
  # GET /rules/1.xml
  def show
    #@rule = Rule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rule }
    end
  end

  # GET /rules/new
  # GET /rules/new.xml
  def new
    @rule = Rule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rule }
    end
  end

  # GET /rules/1/edit
  def edit
    #@rule = Rule.find(params[:id])
  end

  # POST /rules
  # POST /rules.xml
  def create
    @rule = Rule.new(rule_params)

    respond_to do |format|
      if @logged_in.update_site? and @rule.save
        format.html { redirect_to(@rule, :notice => 'Rule was successfully created.') }
        format.xml  { render :xml => @rule, :status => :created, :location => @rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rules/1
  # PUT /rules/1.xml
  def update
    #@rule = Rule.find(params[:id])

    respond_to do |format|
      if @rule.update_attributes(rule_params)
        format.html { redirect_to(@rule, :notice => 'Rule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rules/1
  # DELETE /rules/1.xml
  def destroy
    #@rule = Rule.find(params[:id])
    @rule.destroy

    respond_to do |format|
      format.html { redirect_to(rules_url) }
      format.xml  { head :ok }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @rule = Rule.find(params[:id])
    unless @logged_in.update_site?
      @rule.readonly!
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rule_params
    params.require(:rule).permit(:id, :body)
  end

end
