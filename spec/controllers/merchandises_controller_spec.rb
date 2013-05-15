# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MerchandisesController do

  def mock_merchandise(stubs={})
    @mock_merchandise ||= mock_model(Merchandise, stubs)
  end

  describe "GET index" do
    it "assigns all merchandises as @merchandises" do
      Merchandise.stub(:find).with(:all).and_return([mock_merchandise])
      get :index
      assigns[:merchandises].should == [mock_merchandise]
    end
  end

  describe "GET show" do
    it "assigns the requested merchandise as @merchandise" do
      Merchandise.stub(:find).with("37").and_return(mock_merchandise)
      get :show, :id => "37"
      assigns[:merchandise].should equal(mock_merchandise)
    end
  end

  describe "GET new" do
    it "assigns a new merchandise as @merchandise" do
      Merchandise.stub(:new).and_return(mock_merchandise)
      get :new
      assigns[:merchandise].should equal(mock_merchandise)
    end
  end

  describe "GET edit" do
    it "assigns the requested merchandise as @merchandise" do
      Merchandise.stub(:find).with("37").and_return(mock_merchandise)
      get :edit, :id => "37"
      assigns[:merchandise].should equal(mock_merchandise)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created merchandise as @merchandise" do
        Merchandise.stub(:new).with({'these' => 'params'}).and_return(mock_merchandise(:save => true))
        post :create, :merchandise => {:these => 'params'}
        assigns[:merchandise].should equal(mock_merchandise)
      end

      it "redirects to the created merchandise" do
        Merchandise.stub(:new).and_return(mock_merchandise(:save => true))
        post :create, :merchandise => {}
        response.should redirect_to(merchandise_url(mock_merchandise))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved merchandise as @merchandise" do
        Merchandise.stub(:new).with({'these' => 'params'}).and_return(mock_merchandise(:save => false))
        post :create, :merchandise => {:these => 'params'}
        assigns[:merchandise].should equal(mock_merchandise)
      end

      it "re-renders the 'new' template" do
        Merchandise.stub(:new).and_return(mock_merchandise(:save => false))
        post :create, :merchandise => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested merchandise" do
        Merchandise.should_receive(:find).with("37").and_return(mock_merchandise)
        mock_merchandise.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :merchandise => {:these => 'params'}
      end

      it "assigns the requested merchandise as @merchandise" do
        Merchandise.stub(:find).and_return(mock_merchandise(:update_attributes => true))
        put :update, :id => "1"
        assigns[:merchandise].should equal(mock_merchandise)
      end

      it "redirects to the merchandise" do
        Merchandise.stub(:find).and_return(mock_merchandise(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(merchandise_url(mock_merchandise))
      end
    end

    describe "with invalid params" do
      it "updates the requested merchandise" do
        Merchandise.should_receive(:find).with("37").and_return(mock_merchandise)
        mock_merchandise.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :merchandise => {:these => 'params'}
      end

      it "assigns the merchandise as @merchandise" do
        Merchandise.stub(:find).and_return(mock_merchandise(:update_attributes => false))
        put :update, :id => "1"
        assigns[:merchandise].should equal(mock_merchandise)
      end

      it "re-renders the 'edit' template" do
        Merchandise.stub(:find).and_return(mock_merchandise(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested merchandise" do
      Merchandise.should_receive(:find).with("37").and_return(mock_merchandise)
      mock_merchandise.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the merchandises list" do
      Merchandise.stub(:find).and_return(mock_merchandise(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(merchandises_url)
    end
  end

end
