# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DropsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/drops" }.should route_to(:controller => "drops", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/drops/new" }.should route_to(:controller => "drops", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/drops/1" }.should route_to(:controller => "drops", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/drops/1/edit" }.should route_to(:controller => "drops", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/drops" }.should route_to(:controller => "drops", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/drops/1" }.should route_to(:controller => "drops", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/drops/1" }.should route_to(:controller => "drops", :action => "destroy", :id => "1") 
    end
  end
end
