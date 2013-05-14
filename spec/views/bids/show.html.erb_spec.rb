require 'spec_helper'

describe "/bids/show.html.erb" do
  include BidsHelper
  before(:each) do
    assigns[:bid] = @bid = stub_model(Bid,
      :auction_id => 1,
      :bid_price => 1,
      :character_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
