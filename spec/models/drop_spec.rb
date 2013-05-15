# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Drop do
  before(:each) do
    @valid_attributes = {
      :npc_id => 1,
      :item_template_id => 1,
      :quantity => 1,
      :probability => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Drop.create!(@valid_attributes)
  end
end
