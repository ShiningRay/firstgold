class FormulasController < ApplicationController
  # GET /formulas
  # GET /formulas.xml
  before_filter :find_formula, :except => [:index, :new, :create]
  def index
    @formulas = Formula.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @formulas }
    end
  end

  # GET /formulas/1
  # GET /formulas/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @formula }
    end
  end

  # GET /formulas/new
  # GET /formulas/new.xml
  def new
    @formula = Formula.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @formula }
    end
  end

  # GET /formulas/1/edit
  def edit
  end

  # POST /formulas
  # POST /formulas.xml
  def create
    @formula = Formula.new(params[:formula])
    formula

    respond_to do |format|
      if @formula.save
        flash[:notice] = 'Formula was successfully created.'
        format.html { redirect_to(@formula) }
        format.xml  { render :xml => @formula, :status => :created, :location => @formula }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @formula.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /formulas/1
  # PUT /formulas/1.xml
  def update
    respond_to do |format|
#      params[:inputkeys].collect! {|i|i.to_i}
#      params[:inputvalues].collect! {|i|i.to_i}
#      input = Hash[*params[:inputkeys].zip(params[:inputvalues]).flatten]
#      @formula.input = input
#
#      params[:outputkeys].collect! {|i|i.to_i}
#      params[:outputvalues].collect! {|i|i.to_i}
#      output = Hash[*params[:outputkeys].zip(params[:outputvalues]).flatten]
#      @formula.output = output

      formula

      if @formula.update_attributes(params[:formula])
        
        flash[:notice] = 'Formula was successfully updated.'
        format.html { redirect_to(@formula) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @formula.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /formulas/1
  # DELETE /formulas/1.xml
  def destroy
    @formula.destroy

    respond_to do |format|
      format.html { redirect_to(formulas_url) }
      format.xml  { head :ok }
    end
  end

  def apply
    @formula.apply(current_character)
    flash[:notice] = 'you got ...'
    redirect_to :back
#  rescue InsufficientItem
    
  end

  protected
  def find_formula
    @formula = Formula.find params[:id]
  end

  def formula
     params[:inputkeys].collect! {|i|i.to_i}
      params[:inputvalues].collect! {|i|i.to_i}
      input = Hash[*params[:inputkeys].zip(params[:inputvalues]).flatten]
      @formula.input = input

      params[:outputkeys].collect! {|i|i.to_i}
      params[:outputvalues].collect! {|i|i.to_i}
      output = Hash[*params[:outputkeys].zip(params[:outputvalues]).flatten]
      @formula.output = output
  end
end
