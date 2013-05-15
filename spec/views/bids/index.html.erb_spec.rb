# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/bids/index.html.erb" do
  include BidsHelper

  before(:each) do
    assigns[:bids] = [
      stub_model(Bid,
        :auction_id => 1,
        :bid_price => 1,
        :character_id => 1
      ),
      stub_model(Bid,
        :auction_id => 1,
        :bid_price => 1,
        :character_id => 1
      )
    ]
  end

  it "renders a list of bids" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
