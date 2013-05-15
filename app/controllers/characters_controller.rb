# -*- encoding : utf-8 -*-
class CharactersController < ApplicationController
  before_filter :find_character, :except => [:index, :new, :create]
  # GET /characters
  # GET /characters.xml
  def index
    @characters = current_user.characters.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @characters }
    end
  end
  def inc_point
    return unless @character.points > 0
    @character.inc_point params[:attr].to_sym
    redirect_to :back
    #render :text => @character.points
  end

  # GET /characters/1
  # GET /characters/1.xml
  def show
    session[:character_id ] = @character.id
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/new
  # GET /characters/new.xml
  def new
    @character = current_user.characters.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/1/edit
#  def edit
#    @character = Character.find(params[:id])
#  end

  # POST /characters
  # POST /characters.xml
  def create
    @character = current_user.characters.new(params[:character])
    respond_to do |format|
      if @character.save
        flash[:notice] = 'Character was successfully created.'
        format.html { redirect_to(@character) }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /characters/1
  # PUT /characters/1.xml
  def update
    return unless @character.user_id == current_user.id
    @character = Character[params[:id]]

    respond_to do |format|
      if @character.update_attributes(params[:character])
        flash[:notice] = 'Character was successfully updated.'
        format.html { redirect_to(@character) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.xml
  def destroy
    @character = Character[params[:id]]
    return unless @character.user_id == current_user.id
    @character.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end
  protected
  def find_character
    @character = current_user.characters.find params[:id]
  end
end
