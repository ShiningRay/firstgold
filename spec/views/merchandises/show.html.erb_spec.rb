# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/merchandises/show.html.erb" do
  include MerchandisesHelper
  before(:each) do
    assigns[:merchandise] = @merchandise = stub_model(Merchandise,
      :item_id => 1,
      :price => 1,
      :limit => 1,
      :stock => 1,
      :name => "value for name",
      :description => "value for description",
      :shop_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
  end
end
