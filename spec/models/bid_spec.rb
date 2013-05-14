require 'spec_helper'

describe Bid do
  before(:each) do
    @valid_attributes = {
      :auction_id => 1,
      :bid_price => 1,
      :character_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Bid.create!(@valid_attributes)
  end
end
