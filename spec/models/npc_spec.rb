require 'spec_helper'

describe Npc do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :str => 1,
      :agi => 1,
      :spr => 1,
      :hp => 1,
      :mp => 1,
      :scenario_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Npc.create!(@valid_attributes)
  end
end
