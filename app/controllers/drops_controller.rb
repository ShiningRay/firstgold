# -*- encoding : utf-8 -*-
class DropsController < ApplicationController
  before_filter :find_npc
  before_filter :find_drop, :except => [:index, :new, :create]
  def index
    @drops = @npc.drops.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @drops }
    end
  end
  # GET /drops/1
  # GET /drops/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @drop }
    end
  end

  # GET /drops/new
  # GET /drops/new.xml
  def new
    @drop = @npc.drops.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @drop }
    end
  end

  # GET /drops/1/edit
  def edit
  end

  # POST /drops
  # POST /drops.xml
  def create
    @drop = @npc.drops.new(params[:drop])

    respond_to do |format|
      if @drop.save
        flash[:notice] = 'Drop was successfully created.'
        format.html { redirect_to(@npc) }
        format.xml  { render :xml => @drop, :status => :created, :location => @drop }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /drops/1
  # PUT /drops/1.xml
  def update
    respond_to do |format|
      if @drop.update_attributes(params[:drop])
        flash[:notice] = 'Drop was successfully updated.'
        format.html { redirect_to(@npc) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /drops/1
  # DELETE /drops/1.xml
  def destroy
    @drop.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = 'Removed drop'
        redirect_to(@npc)
      }
      format.xml  { head :ok }
    end
  end
  protected
  def find_npc
    @npc = Npc.find params[:npc_id]
  end
  def find_drop
    @drop = @npc.drops.find params[:id]
  end
end
