class ItemTemplatesController < ApplicationController
  # GET /item_templates
  # GET /item_templates.xml
  def index
    @item_templates = ItemTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @item_templates }
    end
  end

  # GET /item_templates/1
  # GET /item_templates/1.xml
  def show
    @item_template = ItemTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item_template }
    end
  end

  # GET /item_templates/new
  # GET /item_templates/new.xml
  def new
    @item_template = ItemTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item_template }
    end
  end

  # GET /item_templates/1/edit
  def edit
    @item_template = ItemTemplate.find(params[:id])
  end

  # POST /item_templates
  # POST /item_templates.xml
  def create
    @item_template = ItemTemplate.new(params[:item_template])

    respond_to do |format|
      if @item_template.save
        flash[:notice] = 'ItemTemplate was successfully created.'
        format.html { redirect_to(@item_template) }
        format.xml  { render :xml => @item_template, :status => :created, :location => @item_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item_templates/1
  # PUT /item_templates/1.xml
  def update
    @item_template = ItemTemplate.find(params[:id])

    respond_to do |format|
      if @item_template.update_attributes(params[:item_template])
        flash[:notice] = 'ItemTemplate was successfully updated.'
        format.html { redirect_to(@item_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item_templates/1
  # DELETE /item_templates/1.xml
  def destroy
    @item_template = ItemTemplate.find(params[:id])
    @item_template.destroy

    respond_to do |format|
      format.html { redirect_to(item_templates_url) }
      format.xml  { head :ok }
    end
  end
end
