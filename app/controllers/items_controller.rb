class ItemsController < ApplicationController
  # GET /items
  # GET /items.xml
  before_filter :find_character
  before_filter :character_required
  before_filter :require_current_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :find_item, :except => [:index, :new, :create, :destroy]

  def index
    @items = @character.items.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end
  
  def equip
    if @character == current_character && @item.owner == current_character
      @character.equip @item
      @character.save
    end
  rescue
  ensure
    redirect_to @character
  end

  def unequip
    if @character == current_character && @item.owner == current_character
      @character.unequip @item
      @character.save
    end
    redirect_to @character
  end

  def refresh
    if @character == current_character && @item.owner == current_character
      if @item.equipable?
        @item.refresh!
        flash[:notice] = "#{@item.name}'s attributes has been refreshed"
      else
        flash[:error] = "You cannot refresh the attributes of this kind of item"
      end
    end
    redirect_to :back
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to(@item) }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update

    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to(@item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    
    @item.destroy if @character == current_character

    respond_to do |format|
      format.html {
        flash[:notice] = 'item destroyed'
        redirect_to(character_url(@character))
      }
      format.xml  { head :ok }
    end
  end
  protected
  def find_character
    @character = Character.find params[:character_id]
  end
  def find_item
    @item = @character.items.find params[:id]
  end
  def require_current_character
    return redirect_to :back unless current_character == @character or is_admin?
  end
end
