class ScenariosController < ApplicationController
  # GET /scenarios
  # GET /scenarios.xml

  before_filter :find_scenario, :except => [:index, :new, :create]
  before_filter :character_required, :except => [:index, :show]
  before_filter :admin_required, :only => [:new, :create, :destroy]
  
  def index
    @scenarios = {}
    @matrix = {}
    Scenario.all.each do |s|
      @scenarios[s.id] = s
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scenarios }
    end
  end

  def buy

    if @scenario.owner
      flash[:error] = 'This land already had an owner'
      return redirect_to :back
    end
    if current_character.money < 1000
      flash[:error] = 'you do not have enough money'
      return redirect_to :back
    end
    Scenario.transaction do
      current_character.lock!
      @scenario.lock!
      @scenario.owner = current_character
      current_character.money -= 1000
      current_character.save!
      #TODO transaction/deal logs
      @scenario.save!
    end
    flash[:notice] = 'buy successfully'
    redirect_to @scenario
  end

  def sell
    if @scenario.owner == current_character
      Scenario.transaction do
        @scenario.lock!
        current_character.lock!
        @scenario.owner = nil
        @scenario.save!
        #TODO transaction/deal logs
        flash[:notice] = 'Sold successfully'
      end
      redirect_to :back
    else
      flash[:error] = 'You don\'t have perssion to sell the land'
      redirect_to :back
    end
  end

  # GET /scenarios/1
  # GET /scenarios/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /scenarios/new
  # GET /scenarios/new.xml
  def new
    @scenario = Scenario.new :x => params[:x], :y => params[:y]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /scenarios/1/edit
  def edit
  end

  # POST /scenarios
  # POST /scenarios.xml
  def create
    @scenario = Scenario.new(params[:scenario])

    respond_to do |format|
      if @scenario.save
        flash[:notice] = 'Scenario was successfully created.'
        format.html { redirect_to(@scenario) }
        format.xml  { render :xml => @scenario, :status => :created, :location => @scenario }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scenarios/1
  # PUT /scenarios/1.xml
  def update
    @scenario.update_attributes(params[:scenario])
    respond_to do |format|
      if @scenario.save
        flash[:notice] = 'Scenario was successfully updated.'
        format.html { redirect_to(@scenario) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.xml
  def destroy
    @scenario.destroy

    respond_to do |format|
      format.html { redirect_to(scenarios_url) }
      format.xml  { head :ok }
    end
  end
  protected
  def find_scenario
    @scenario = Scenario.find_by_coordinate(*params[:id].split(/-/))
  end
end
