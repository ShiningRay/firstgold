class AuctionsController < ApplicationController
  # GET /auctions
  # GET /auctions.xml
  before_filter :find_auction, :only => [:show, :edit, :update, :destroy, :buyout]
  before_filter :character_required, :only => [:new, :create, :buyout, :destroy]
  
  def index
    @auctions = Auction.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @auctions }
    end
  end

  # GET /auctions/1
  # GET /auctions/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @auction }
    end
  end

  # GET /auctions/new
  # GET /auctions/new.xml
  def new
    @auction = Auction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @auction }
    end
  end

  # GET /auctions/1/edit
  def edit
  end

  # POST /auctions
  # POST /auctions.xml
  def create
    @auction = Auction.new(params[:auction])
    @auction.seller = current_character
    @auction.upset_price = @auction.buyout_price

    respond_to do |format|
      if @auction.save
        flash[:notice] = 'Auction was successfully created.'
        format.html { redirect_to(@auction) }
        format.xml  { render :xml => @auction, :status => :created, :location => @auction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /auctions/1
  # PUT /auctions/1.xml
  def update

    respond_to do |format|
      if @auction.update_attributes(params[:auction])
        flash[:notice] = 'Auction was successfully updated.'
        format.html { redirect_to(@auction) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /auctions/1
  # DELETE /auctions/1.xml
  def destroy
    if current_characet == @auction.owner
      @auction.destroy
    else
      flash[:error] = 'You do not have permission to cancel the auction'
    end

    respond_to do |format|
      format.html { redirect_to(auctions_url) }
      format.xml  { head :ok }
    end
  end


  def buyout
    unless @auction.buyout_price
      flash[:error] = 'This auction cannot buyout'
      return redirect_to @auction
    end
    
    unless current_character.money > @auction.buyout_price
      flash[:error] = 'You do not have enough money'
      return redirect_to :back
    end

    unless @auction.status == 'open'
      flash[:error] = 'This auction is closed'
      return redirect_to :back
    end

    if @auction.seller == current_character
      flash[:error] = 'You cannot buy your own auction'
      return redirect_to :back
    end
    @auction.buyout(current_character)
    
    flash[:notice] = 'You successfully buyout this item'
    return redirect_to @auction
  end
  protected
  def find_auction
    @auction = Auction.find params[:id]
  end
end
