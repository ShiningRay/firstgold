class BidsController < ApplicationController
  # GET /bids
  # GET /bids.xml
  before_filter :login_required
  before_filter :character_required
  before_filter :find_auction
  before_filter :find_bid, :only => [:show, :edit, :update, :destroy]
  
  def index
    @bids = @auction.bids.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bids }
    end
  end

  # GET /bids/1
  # GET /bids/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bid }
    end
  end

  # GET /bids/new
  # GET /bids/new.xml
  def new
    @bid = Bid.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bid }
    end
  end

  # GET /bids/1/edit
  def edit
  end

  # POST /bids
  # POST /bids.xml
  def create
    @bid = @auction.bids.new(params[:bid])
    @bid.bidder = current_character

    respond_to do |format|
      if @bid.save
        flash[:notice] = 'Bid was successfully created.'
        format.html { redirect_to(auction_bids_path(@auction)) }
        format.xml  { render :xml => @bid, :status => :created, :location => @bid }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bids/1
  # PUT /bids/1.xml
  def update

    respond_to do |format|
      if @bid.update_attributes(params[:bid])
        flash[:notice] = 'Bid was successfully updated.'
        format.html { redirect_to(@bid) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.xml
  def destroy
    @bid.destroy

    respond_to do |format|
      format.html { redirect_to(bids_url) }
      format.xml  { head :ok }
    end
  end
  protected
  def find_auction
    @auction = Auction.find params[:auction_id] if params[:auction_id]
  end
  def find_bid
    @bid = @auction.bids.find params[:id]
  end
end
