# -*- encoding : utf-8 -*-
class MerchandisesController < ApplicationController
  # GET /merchandises
  # GET /merchandises.xml
  before_filter :find_shop
  before_filter :find_merchandise, :only => [:show, :buy, :edit, :update, :destroy]
  before_filter :character_required, :only => :buy
  before_filter :admin_required, :except => [:index, :show]
  
  def index
    @merchandises = @shop.merchandises.all

    respond_to do |format|
      format.html {
        render :layout => false if request.xhr?
      }
      format.xml  { render :xml => @merchandises }
    end
  end

  # GET /merchandises/1
  # GET /merchandises/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchandise }
    end
  end

  def buy
    if current_character.money < @merchandise.price
      flash[:error] = 'You do not have enough money'
      return redirect_to :back
    end
    unless @merchandise.has_stock?
      flash[:error] = 'That kind of goods has been sold out'
      return redirect_to :back
    end

    Shop.transaction do
      @merchandise.lock!
      current_character.lock!
      current_character.money -= @merchandise.price
      current_character.items << @merchandise.item_template.generate
      @merchandise.decr_stock
      current_character.save!
      @merchandise.save!
    end
    flash[:notice] = "bought #{@merchandise.name} costs #{@merchandise.price}"
    return redirect_to :back
  end

  # GET /merchandises/new
  # GET /merchandises/new.xml
  def new
    @merchandise = @shop.merchandises.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merchandise }
    end
  end

  # GET /merchandises/1/edit
  def edit
  end

  # POST /merchandises
  # POST /merchandises.xml
  def create
    @merchandise = @shop.merchandises.new(params[:merchandise])

    respond_to do |format|
      if @merchandise.save
        flash[:notice] = 'Merchandise was successfully created.'
        format.html { redirect_to(shop_merchandises_path(@shop)) }
        format.xml  { render :xml => @merchandise, :status => :created, :location => @merchandise }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merchandise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /merchandises/1
  # PUT /merchandises/1.xml
  def update

    respond_to do |format|
      if @merchandise.update_attributes(params[:merchandise])
        flash[:notice] = 'Merchandise was successfully updated.'
        format.html { redirect_to(shop_merchandises_path(@shop)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchandise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /merchandises/1
  # DELETE /merchandises/1.xml
  def destroy
    @merchandise.destroy

    respond_to do |format|
      format.html { redirect_to(shop_merchandises_path(@shop)) }
      format.xml  { head :ok }
    end
  end
  protected
  def find_shop
    @shop = Shop.find params[:shop_id] if params[:shop_id]
  end
  def find_merchandise
    @merchandise = @shop.merchandises.find params[:id]
  end
end
