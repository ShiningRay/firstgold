require 'spec_helper'

describe "/npcs/index.html.erb" do
  include NpcsHelper

  before(:each) do
    assigns[:npcs] = [
      stub_model(Npc,
        :name => "value for name",
        :description => "value for description",
        :str => 1,
        :agi => 1,
        :spr => 1,
        :hp => 1,
        :mp => 1,
        :scenario_id => 1
      ),
      stub_model(Npc,
        :name => "value for name",
        :description => "value for description",
        :str => 1,
        :agi => 1,
        :spr => 1,
        :hp => 1,
        :mp => 1,
        :scenario_id => 1
      )
    ]
  end

  it "renders a list of npcs" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
