require 'spec_helper'

describe "/drops/index.html.erb" do
  include DropsHelper

  before(:each) do
    assigns[:drops] = [
      stub_model(Drop,
        :npc_id => 1,
        :item_template_id => 1,
        :quantity => 1,
        :probability => 1
      ),
      stub_model(Drop,
        :npc_id => 1,
        :item_template_id => 1,
        :quantity => 1,
        :probability => 1
      )
    ]
  end

  it "renders a list of drops" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
