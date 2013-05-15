# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/drops/show.html.erb" do
  include DropsHelper
  before(:each) do
    assigns[:drop] = @drop = stub_model(Drop,
      :npc_id => 1,
      :item_template_id => 1,
      :quantity => 1,
      :probability => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
