require 'spec_helper'

describe MerchandisesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/merchandises" }.should route_to(:controller => "merchandises", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/merchandises/new" }.should route_to(:controller => "merchandises", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/merchandises/1" }.should route_to(:controller => "merchandises", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/merchandises/1/edit" }.should route_to(:controller => "merchandises", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/merchandises" }.should route_to(:controller => "merchandises", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/merchandises/1" }.should route_to(:controller => "merchandises", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/merchandises/1" }.should route_to(:controller => "merchandises", :action => "destroy", :id => "1") 
    end
  end
end
