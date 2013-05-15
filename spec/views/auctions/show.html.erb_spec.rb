# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/auctions/show.html.erb" do
  include AuctionsHelper
  before(:each) do
    assigns[:auction] = @auction = stub_model(Auction,
      :item_id => 1,
      :quantity => 1,
      :description => "value for description",
      :upset_price => 1,
      :increment => 1,
      :status => "value for status"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ status/)
  end
end
