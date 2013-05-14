require 'spec_helper'

describe Merchandise do
  before(:each) do
    @valid_attributes = {
      :item_id => 1,
      :price => 1,
      :limit => 1,
      :stock => 1,
      :name => "value for name",
      :description => "value for description",
      :shop_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Merchandise.create!(@valid_attributes)
  end
end
