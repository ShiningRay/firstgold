require 'spec_helper'

describe "/bids/new.html.erb" do
  include BidsHelper

  before(:each) do
    assigns[:bid] = stub_model(Bid,
      :new_record? => true,
      :auction_id => 1,
      :bid_price => 1,
      :character_id => 1
    )
  end

  it "renders new bid form" do
    render

    response.should have_tag("form[action=?][method=post]", bids_path) do
      with_tag("input#bid_auction_id[name=?]", "bid[auction_id]")
      with_tag("input#bid_bid_price[name=?]", "bid[bid_price]")
      with_tag("input#bid_character_id[name=?]", "bid[character_id]")
    end
  end
end
