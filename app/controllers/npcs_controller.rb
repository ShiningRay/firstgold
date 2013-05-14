class NpcsController < ApplicationController
  before_filter :admin_required, :except => :show
  before_filter :find_npc, :except => [:index, :new, :create]
  # GET /npcs
  # GET /npcs.xml
  def index
    @npcs = NPC.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @npcs }
    end
  end

  #copy an npc to a new one
  def copy
    @new_npc = @npc.clone
    @new_npc.name = params[:name]
    @new_npc.save
    @npc.drops.each do |d|
      @new_npc.drops << d.clone
    end
    redirect_to npc_path(@new_npc)
  end

  # GET /npcs/1
  # GET /npcs/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @npc }
    end
  end

  # GET /npcs/new
  # GET /npcs/new.xml
  def new
    @npc = NPC.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @npc }
    end
  end

  # GET /npcs/1/edit
  def edit
    
  end

  # POST /npcs
  # POST /npcs.xml
  def create
    @npc = Npc.new(params[:npc])

    respond_to do |format|
      if @npc.save
        flash[:notice] = 'NPC was successfully created.'
        format.html { redirect_to(@npc) }
        format.xml  { render :xml => @npc, :status => :created, :location => @npc }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @npc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /npcs/1
  # PUT /npcs/1.xml
  def update
    @npc = NPC.find params[:id]
    @npc.update_attributes(params[:npc])
    respond_to do |format|
      if @npc.save
        flash[:notice] = 'NPC was successfully updated.'
        format.html { redirect_to(@npc) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @npc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /npcs/1
  # DELETE /npcs/1.xml
  def destroy
    @npc = NPC.find params[:id]
    @npc.destroy

    respond_to do |format|
      format.html { redirect_to(npcs_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def find_scenario
    @scenario = Scenario.find params[:scenario_id]
#  rescue
  end
  def find_npc
    @npc = NPC.find params[:id]
  end
end
