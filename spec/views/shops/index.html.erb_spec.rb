# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/shops/index.html.erb" do
  include ShopsHelper

  before(:each) do
    assigns[:shops] = [
      stub_model(Shop,
        :name => "value for name",
        :description => "value for description",
        :npc_id => 1
      ),
      stub_model(Shop,
        :name => "value for name",
        :description => "value for description",
        :npc_id => 1
      )
    ]
  end

  it "renders a list of shops" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
