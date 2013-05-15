# -*- encoding : utf-8 -*-
require File.dirname(__FILE__)+ '/../spec_helper'


describe NpcsController do

  def mock_npc(stubs={})
    @mock_npc ||= mock_model(Npc, stubs)
  end

  describe "GET index" do
    it "assigns all npcs as @npcs" do
      Npc.stub(:find).with(:all).and_return([mock_npc])
      get :index
      assigns[:npcs].should == [mock_npc]
    end
  end

  describe "GET show" do
    it "assigns the requested npc as @npc" do
      Npc.stub(:find).with("37").and_return(mock_npc)
      get :show, :id => "37"
      assigns[:npc].should equal(mock_npc)
    end
  end

  describe "GET new" do
    it "assigns a new npc as @npc" do
      Npc.stub(:new).and_return(mock_npc)
      get :new
      assigns[:npc].should equal(mock_npc)
    end
  end

  describe "GET edit" do
    it "assigns the requested npc as @npc" do
      Npc.stub(:find).with("37").and_return(mock_npc)
      get :edit, :id => "37"
      assigns[:npc].should equal(mock_npc)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created npc as @npc" do
        Npc.stub(:new).with({'these' => 'params'}).and_return(mock_npc(:save => true))
        post :create, :npc => {:these => 'params'}
        assigns[:npc].should equal(mock_npc)
      end

      it "redirects to the created npc" do
        Npc.stub(:new).and_return(mock_npc(:save => true))
        post :create, :npc => {}
        response.should redirect_to(npc_url(mock_npc))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved npc as @npc" do
        Npc.stub(:new).with({'these' => 'params'}).and_return(mock_npc(:save => false))
        post :create, :npc => {:these => 'params'}
        assigns[:npc].should equal(mock_npc)
      end

      it "re-renders the 'new' template" do
        Npc.stub(:new).and_return(mock_npc(:save => false))
        post :create, :npc => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested npc" do
        Npc.should_receive(:find).with("37").and_return(mock_npc)
        mock_npc.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :npc => {:these => 'params'}
      end

      it "assigns the requested npc as @npc" do
        Npc.stub(:find).and_return(mock_npc(:update_attributes => true))
        put :update, :id => "1"
        assigns[:npc].should equal(mock_npc)
      end

      it "redirects to the npc" do
        Npc.stub(:find).and_return(mock_npc(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(npc_url(mock_npc))
      end
    end

    describe "with invalid params" do
      it "updates the requested npc" do
        Npc.should_receive(:find).with("37").and_return(mock_npc)
        mock_npc.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :npc => {:these => 'params'}
      end

      it "assigns the npc as @npc" do
        Npc.stub(:find).and_return(mock_npc(:update_attributes => false))
        put :update, :id => "1"
        assigns[:npc].should equal(mock_npc)
      end

      it "re-renders the 'edit' template" do
        Npc.stub(:find).and_return(mock_npc(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested npc" do
      Npc.should_receive(:find).with("37").and_return(mock_npc)
      mock_npc.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the npcs list" do
      Npc.stub(:find).and_return(mock_npc(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(npcs_url)
    end
  end

end
