require 'spec_helper'

describe "/item_templates/index.html.erb" do
  include ItemTemplatesHelper

  before(:each) do
    assigns[:item_templates] = [
      stub_model(ItemTemplate,
        :name => "value for name",
        :price => 1,
        :slot => "value for slot",
        :max_stack => 1,
        :extra => "value for extra"
      ),
      stub_model(ItemTemplate,
        :name => "value for name",
        :price => 1,
        :slot => "value for slot",
        :max_stack => 1,
        :extra => "value for extra"
      )
    ]
  end

  it "renders a list of item_templates" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for slot".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for extra".to_s, 2)
  end
end
