require 'spec_helper'

describe BidsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/bids" }.should route_to(:controller => "bids", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/bids/new" }.should route_to(:controller => "bids", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/bids/1" }.should route_to(:controller => "bids", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/bids/1/edit" }.should route_to(:controller => "bids", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/bids" }.should route_to(:controller => "bids", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/bids/1" }.should route_to(:controller => "bids", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/bids/1" }.should route_to(:controller => "bids", :action => "destroy", :id => "1") 
    end
  end
end
