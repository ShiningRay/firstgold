require 'spec_helper'

describe "/auctions/edit.html.erb" do
  include AuctionsHelper

  before(:each) do
    assigns[:auction] = @auction = stub_model(Auction,
      :new_record? => false,
      :item_id => 1,
      :quantity => 1,
      :description => "value for description",
      :upset_price => 1,
      :increment => 1,
      :status => "value for status"
    )
  end

  it "renders the edit auction form" do
    render

    response.should have_tag("form[action=#{auction_path(@auction)}][method=post]") do
      with_tag('input#auction_item_id[name=?]', "auction[item_id]")
      with_tag('input#auction_quantity[name=?]', "auction[quantity]")
      with_tag('textarea#auction_description[name=?]', "auction[description]")
      with_tag('input#auction_upset_price[name=?]', "auction[upset_price]")
      with_tag('input#auction_increment[name=?]', "auction[increment]")
      with_tag('input#auction_status[name=?]', "auction[status]")
    end
  end
end
