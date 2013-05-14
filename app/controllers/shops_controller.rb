class ShopsController < ApplicationController
  # GET /shops
  # GET /shops.xml
  before_filter :find_shop, :except => [:index, :new, :create]
  before_filter :admin_required, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @shops = Shop.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shops }
    end
  end

  # GET /shops/1
  # GET /shops/1.xml
  def show

    respond_to do |format|
      format.html {
        render :layout => false if request.xhr?
      }
      format.xml  { render :xml => @shop }
    end
  end

  # GET /shops/new
  # GET /shops/new.xml
  def new
    @shop = Shop.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shop }
    end
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops
  # POST /shops.xml
  def create
    @shop = Shop.new(params[:shop])

    respond_to do |format|
      if @shop.save
        flash[:notice] = 'Shop was successfully created.'
        format.html { redirect_to(@shop) }
        format.xml  { render :xml => @shop, :status => :created, :location => @shop }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1
  # PUT /shops/1.xml
  def update

    respond_to do |format|
      if @shop.update_attributes(params[:shop])
        flash[:notice] = 'Shop was successfully updated.'
        format.html { redirect_to(@shop) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.xml
  def destroy
    @shop.destroy

    respond_to do |format|
      format.html { redirect_to(shops_url) }
      format.xml  { head :ok }
    end
  end
  protected
  def find_shop
    @shop = Shop.find(params[:id])
  end
end
