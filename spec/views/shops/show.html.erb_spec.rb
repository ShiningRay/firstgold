# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/shops/show.html.erb" do
  include ShopsHelper
  before(:each) do
    assigns[:shop] = @shop = stub_model(Shop,
      :name => "value for name",
      :description => "value for description",
      :npc_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
  end
end
