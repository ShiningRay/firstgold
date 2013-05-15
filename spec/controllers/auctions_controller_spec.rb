# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AuctionsController do

  def mock_auction(stubs={})
    @mock_auction ||= mock_model(Auction, stubs)
  end

  describe "GET index" do
    it "assigns all auctions as @auctions" do
      Auction.stub(:find).with(:all).and_return([mock_auction])
      get :index
      assigns[:auctions].should == [mock_auction]
    end
  end

  describe "GET show" do
    it "assigns the requested auction as @auction" do
      Auction.stub(:find).with("37").and_return(mock_auction)
      get :show, :id => "37"
      assigns[:auction].should equal(mock_auction)
    end
  end

  describe "GET new" do
    it "assigns a new auction as @auction" do
      Auction.stub(:new).and_return(mock_auction)
      get :new
      assigns[:auction].should equal(mock_auction)
    end
  end

  describe "GET edit" do
    it "assigns the requested auction as @auction" do
      Auction.stub(:find).with("37").and_return(mock_auction)
      get :edit, :id => "37"
      assigns[:auction].should equal(mock_auction)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created auction as @auction" do
        Auction.stub(:new).with({'these' => 'params'}).and_return(mock_auction(:save => true))
        post :create, :auction => {:these => 'params'}
        assigns[:auction].should equal(mock_auction)
      end

      it "redirects to the created auction" do
        Auction.stub(:new).and_return(mock_auction(:save => true))
        post :create, :auction => {}
        response.should redirect_to(auction_url(mock_auction))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved auction as @auction" do
        Auction.stub(:new).with({'these' => 'params'}).and_return(mock_auction(:save => false))
        post :create, :auction => {:these => 'params'}
        assigns[:auction].should equal(mock_auction)
      end

      it "re-renders the 'new' template" do
        Auction.stub(:new).and_return(mock_auction(:save => false))
        post :create, :auction => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested auction" do
        Auction.should_receive(:find).with("37").and_return(mock_auction)
        mock_auction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :auction => {:these => 'params'}
      end

      it "assigns the requested auction as @auction" do
        Auction.stub(:find).and_return(mock_auction(:update_attributes => true))
        put :update, :id => "1"
        assigns[:auction].should equal(mock_auction)
      end

      it "redirects to the auction" do
        Auction.stub(:find).and_return(mock_auction(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(auction_url(mock_auction))
      end
    end

    describe "with invalid params" do
      it "updates the requested auction" do
        Auction.should_receive(:find).with("37").and_return(mock_auction)
        mock_auction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :auction => {:these => 'params'}
      end

      it "assigns the auction as @auction" do
        Auction.stub(:find).and_return(mock_auction(:update_attributes => false))
        put :update, :id => "1"
        assigns[:auction].should equal(mock_auction)
      end

      it "re-renders the 'edit' template" do
        Auction.stub(:find).and_return(mock_auction(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested auction" do
      Auction.should_receive(:find).with("37").and_return(mock_auction)
      mock_auction.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the auctions list" do
      Auction.stub(:find).and_return(mock_auction(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(auctions_url)
    end
  end

end
