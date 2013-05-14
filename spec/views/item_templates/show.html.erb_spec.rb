require 'spec_helper'

describe "/item_templates/show.html.erb" do
  include ItemTemplatesHelper
  before(:each) do
    assigns[:item_template] = @item_template = stub_model(ItemTemplate,
      :name => "value for name",
      :price => 1,
      :slot => "value for slot",
      :max_stack => 1,
      :extra => "value for extra"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ slot/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ extra/)
  end
end
