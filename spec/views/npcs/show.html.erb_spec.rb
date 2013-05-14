require 'spec_helper'

describe "/npcs/show.html.erb" do
  include NpcsHelper
  before(:each) do
    assigns[:npc] = @npc = stub_model(Npc,
      :name => "value for name",
      :description => "value for description",
      :str => 1,
      :agi => 1,
      :spr => 1,
      :hp => 1,
      :mp => 1,
      :scenario_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
