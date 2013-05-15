# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mail do
  before(:each) do
    @valid_attributes = {
      :owner_id => 1,
      :send_id => 1,
      :recipient_id => 1,
      :content => "value for content",
      :read => false,
      :attachment => "value for attachment"
    }
  end

  it "should create a new instance given valid attributes" do
    Mail.create!(@valid_attributes)
  end
end
