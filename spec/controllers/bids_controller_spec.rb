# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BidsController do

  def mock_bid(stubs={})
    @mock_bid ||= mock_model(Bid, stubs)
  end

  describe "GET index" do
    it "assigns all bids as @bids" do
      Bid.stub(:find).with(:all).and_return([mock_bid])
      get :index
      assigns[:bids].should == [mock_bid]
    end
  end

  describe "GET show" do
    it "assigns the requested bid as @bid" do
      Bid.stub(:find).with("37").and_return(mock_bid)
      get :show, :id => "37"
      assigns[:bid].should equal(mock_bid)
    end
  end

  describe "GET new" do
    it "assigns a new bid as @bid" do
      Bid.stub(:new).and_return(mock_bid)
      get :new
      assigns[:bid].should equal(mock_bid)
    end
  end

  describe "GET edit" do
    it "assigns the requested bid as @bid" do
      Bid.stub(:find).with("37").and_return(mock_bid)
      get :edit, :id => "37"
      assigns[:bid].should equal(mock_bid)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created bid as @bid" do
        Bid.stub(:new).with({'these' => 'params'}).and_return(mock_bid(:save => true))
        post :create, :bid => {:these => 'params'}
        assigns[:bid].should equal(mock_bid)
      end

      it "redirects to the created bid" do
        Bid.stub(:new).and_return(mock_bid(:save => true))
        post :create, :bid => {}
        response.should redirect_to(bid_url(mock_bid))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bid as @bid" do
        Bid.stub(:new).with({'these' => 'params'}).and_return(mock_bid(:save => false))
        post :create, :bid => {:these => 'params'}
        assigns[:bid].should equal(mock_bid)
      end

      it "re-renders the 'new' template" do
        Bid.stub(:new).and_return(mock_bid(:save => false))
        post :create, :bid => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested bid" do
        Bid.should_receive(:find).with("37").and_return(mock_bid)
        mock_bid.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :bid => {:these => 'params'}
      end

      it "assigns the requested bid as @bid" do
        Bid.stub(:find).and_return(mock_bid(:update_attributes => true))
        put :update, :id => "1"
        assigns[:bid].should equal(mock_bid)
      end

      it "redirects to the bid" do
        Bid.stub(:find).and_return(mock_bid(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(bid_url(mock_bid))
      end
    end

    describe "with invalid params" do
      it "updates the requested bid" do
        Bid.should_receive(:find).with("37").and_return(mock_bid)
        mock_bid.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :bid => {:these => 'params'}
      end

      it "assigns the bid as @bid" do
        Bid.stub(:find).and_return(mock_bid(:update_attributes => false))
        put :update, :id => "1"
        assigns[:bid].should equal(mock_bid)
      end

      it "re-renders the 'edit' template" do
        Bid.stub(:find).and_return(mock_bid(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested bid" do
      Bid.should_receive(:find).with("37").and_return(mock_bid)
      mock_bid.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the bids list" do
      Bid.stub(:find).and_return(mock_bid(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(bids_url)
    end
  end

end
