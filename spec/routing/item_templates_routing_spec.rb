# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ItemTemplatesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/item_templates" }.should route_to(:controller => "item_templates", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/item_templates/new" }.should route_to(:controller => "item_templates", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/item_templates/1" }.should route_to(:controller => "item_templates", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/item_templates/1/edit" }.should route_to(:controller => "item_templates", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/item_templates" }.should route_to(:controller => "item_templates", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/item_templates/1" }.should route_to(:controller => "item_templates", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/item_templates/1" }.should route_to(:controller => "item_templates", :action => "destroy", :id => "1") 
    end
  end
end
