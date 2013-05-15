# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ShopsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/shops" }.should route_to(:controller => "shops", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/shops/new" }.should route_to(:controller => "shops", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/shops/1" }.should route_to(:controller => "shops", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/shops/1/edit" }.should route_to(:controller => "shops", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/shops" }.should route_to(:controller => "shops", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/shops/1" }.should route_to(:controller => "shops", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/shops/1" }.should route_to(:controller => "shops", :action => "destroy", :id => "1") 
    end
  end
end
