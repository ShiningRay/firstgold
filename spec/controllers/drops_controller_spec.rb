require 'spec_helper'

describe DropsController do

  def mock_drop(stubs={})
    @mock_drop ||= mock_model(Drop, stubs)
  end

  describe "GET index" do
    it "assigns all drops as @drops" do
      Drop.stub(:find).with(:all).and_return([mock_drop])
      get :index
      assigns[:drops].should == [mock_drop]
    end
  end

  describe "GET show" do
    it "assigns the requested drop as @drop" do
      Drop.stub(:find).with("37").and_return(mock_drop)
      get :show, :id => "37"
      assigns[:drop].should equal(mock_drop)
    end
  end

  describe "GET new" do
    it "assigns a new drop as @drop" do
      Drop.stub(:new).and_return(mock_drop)
      get :new
      assigns[:drop].should equal(mock_drop)
    end
  end

  describe "GET edit" do
    it "assigns the requested drop as @drop" do
      Drop.stub(:find).with("37").and_return(mock_drop)
      get :edit, :id => "37"
      assigns[:drop].should equal(mock_drop)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created drop as @drop" do
        Drop.stub(:new).with({'these' => 'params'}).and_return(mock_drop(:save => true))
        post :create, :drop => {:these => 'params'}
        assigns[:drop].should equal(mock_drop)
      end

      it "redirects to the created drop" do
        Drop.stub(:new).and_return(mock_drop(:save => true))
        post :create, :drop => {}
        response.should redirect_to(drop_url(mock_drop))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved drop as @drop" do
        Drop.stub(:new).with({'these' => 'params'}).and_return(mock_drop(:save => false))
        post :create, :drop => {:these => 'params'}
        assigns[:drop].should equal(mock_drop)
      end

      it "re-renders the 'new' template" do
        Drop.stub(:new).and_return(mock_drop(:save => false))
        post :create, :drop => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested drop" do
        Drop.should_receive(:find).with("37").and_return(mock_drop)
        mock_drop.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :drop => {:these => 'params'}
      end

      it "assigns the requested drop as @drop" do
        Drop.stub(:find).and_return(mock_drop(:update_attributes => true))
        put :update, :id => "1"
        assigns[:drop].should equal(mock_drop)
      end

      it "redirects to the drop" do
        Drop.stub(:find).and_return(mock_drop(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(drop_url(mock_drop))
      end
    end

    describe "with invalid params" do
      it "updates the requested drop" do
        Drop.should_receive(:find).with("37").and_return(mock_drop)
        mock_drop.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :drop => {:these => 'params'}
      end

      it "assigns the drop as @drop" do
        Drop.stub(:find).and_return(mock_drop(:update_attributes => false))
        put :update, :id => "1"
        assigns[:drop].should equal(mock_drop)
      end

      it "re-renders the 'edit' template" do
        Drop.stub(:find).and_return(mock_drop(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested drop" do
      Drop.should_receive(:find).with("37").and_return(mock_drop)
      mock_drop.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the drops list" do
      Drop.stub(:find).and_return(mock_drop(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(drops_url)
    end
  end

end
