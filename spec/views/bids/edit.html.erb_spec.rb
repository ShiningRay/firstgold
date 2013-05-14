require 'spec_helper'

describe "/bids/edit.html.erb" do
  include BidsHelper

  before(:each) do
    assigns[:bid] = @bid = stub_model(Bid,
      :new_record? => false,
      :auction_id => 1,
      :bid_price => 1,
      :character_id => 1
    )
  end

  it "renders the edit bid form" do
    render

    response.should have_tag("form[action=#{bid_path(@bid)}][method=post]") do
      with_tag('input#bid_auction_id[name=?]', "bid[auction_id]")
      with_tag('input#bid_bid_price[name=?]', "bid[bid_price]")
      with_tag('input#bid_character_id[name=?]', "bid[character_id]")
    end
  end
end
