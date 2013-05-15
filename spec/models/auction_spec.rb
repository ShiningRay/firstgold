# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Auction do
  before(:each) do
    @valid_attributes = {
      :item_id => 1,
      :quantity => 1,
      :description => "value for description",
      :upset_price => 1,
      :increment => 1,
      :status => "value for status",
      :expiration => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Auction.create!(@valid_attributes)
  end
end
