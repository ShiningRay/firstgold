# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ItemTemplatesController do

  def mock_item_template(stubs={})
    @mock_item_template ||= mock_model(ItemTemplate, stubs)
  end

  describe "GET index" do
    it "assigns all item_templates as @item_templates" do
      ItemTemplate.stub(:find).with(:all).and_return([mock_item_template])
      get :index
      assigns[:item_templates].should == [mock_item_template]
    end
  end

  describe "GET show" do
    it "assigns the requested item_template as @item_template" do
      ItemTemplate.stub(:find).with("37").and_return(mock_item_template)
      get :show, :id => "37"
      assigns[:item_template].should equal(mock_item_template)
    end
  end

  describe "GET new" do
    it "assigns a new item_template as @item_template" do
      ItemTemplate.stub(:new).and_return(mock_item_template)
      get :new
      assigns[:item_template].should equal(mock_item_template)
    end
  end

  describe "GET edit" do
    it "assigns the requested item_template as @item_template" do
      ItemTemplate.stub(:find).with("37").and_return(mock_item_template)
      get :edit, :id => "37"
      assigns[:item_template].should equal(mock_item_template)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created item_template as @item_template" do
        ItemTemplate.stub(:new).with({'these' => 'params'}).and_return(mock_item_template(:save => true))
        post :create, :item_template => {:these => 'params'}
        assigns[:item_template].should equal(mock_item_template)
      end

      it "redirects to the created item_template" do
        ItemTemplate.stub(:new).and_return(mock_item_template(:save => true))
        post :create, :item_template => {}
        response.should redirect_to(item_template_url(mock_item_template))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved item_template as @item_template" do
        ItemTemplate.stub(:new).with({'these' => 'params'}).and_return(mock_item_template(:save => false))
        post :create, :item_template => {:these => 'params'}
        assigns[:item_template].should equal(mock_item_template)
      end

      it "re-renders the 'new' template" do
        ItemTemplate.stub(:new).and_return(mock_item_template(:save => false))
        post :create, :item_template => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested item_template" do
        ItemTemplate.should_receive(:find).with("37").and_return(mock_item_template)
        mock_item_template.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :item_template => {:these => 'params'}
      end

      it "assigns the requested item_template as @item_template" do
        ItemTemplate.stub(:find).and_return(mock_item_template(:update_attributes => true))
        put :update, :id => "1"
        assigns[:item_template].should equal(mock_item_template)
      end

      it "redirects to the item_template" do
        ItemTemplate.stub(:find).and_return(mock_item_template(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(item_template_url(mock_item_template))
      end
    end

    describe "with invalid params" do
      it "updates the requested item_template" do
        ItemTemplate.should_receive(:find).with("37").and_return(mock_item_template)
        mock_item_template.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :item_template => {:these => 'params'}
      end

      it "assigns the item_template as @item_template" do
        ItemTemplate.stub(:find).and_return(mock_item_template(:update_attributes => false))
        put :update, :id => "1"
        assigns[:item_template].should equal(mock_item_template)
      end

      it "re-renders the 'edit' template" do
        ItemTemplate.stub(:find).and_return(mock_item_template(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested item_template" do
      ItemTemplate.should_receive(:find).with("37").and_return(mock_item_template)
      mock_item_template.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the item_templates list" do
      ItemTemplate.stub(:find).and_return(mock_item_template(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(item_templates_url)
    end
  end

end
