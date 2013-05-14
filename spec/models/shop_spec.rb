require 'spec_helper'

describe Shop do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :npc_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Shop.create!(@valid_attributes)
  end
end
