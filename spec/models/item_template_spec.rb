# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ItemTemplate do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :price => 1,
      :slot => "value for slot",
      :max_stack => 1,
      :extra => "value for extra"
    }
  end

  it "should create a new instance given valid attributes" do
    ItemTemplate.create!(@valid_attributes)
  end
end
