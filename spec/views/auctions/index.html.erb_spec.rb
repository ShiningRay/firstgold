require 'spec_helper'

describe "/auctions/index.html.erb" do
  include AuctionsHelper

  before(:each) do
    assigns[:auctions] = [
      stub_model(Auction,
        :item_id => 1,
        :quantity => 1,
        :description => "value for description",
        :upset_price => 1,
        :increment => 1,
        :status => "value for status"
      ),
      stub_model(Auction,
        :item_id => 1,
        :quantity => 1,
        :description => "value for description",
        :upset_price => 1,
        :increment => 1,
        :status => "value for status"
      )
    ]
  end

  it "renders a list of auctions" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for status".to_s, 2)
  end
end
