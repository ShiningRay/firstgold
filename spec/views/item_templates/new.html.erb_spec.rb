require 'spec_helper'

describe "/item_templates/new.html.erb" do
  include ItemTemplatesHelper

  before(:each) do
    assigns[:item_template] = stub_model(ItemTemplate,
      :new_record? => true,
      :name => "value for name",
      :price => 1,
      :slot => "value for slot",
      :max_stack => 1,
      :extra => "value for extra"
    )
  end

  it "renders new item_template form" do
    render

    response.should have_tag("form[action=?][method=post]", item_templates_path) do
      with_tag("input#item_template_name[name=?]", "item_template[name]")
      with_tag("input#item_template_price[name=?]", "item_template[price]")
      with_tag("input#item_template_slot[name=?]", "item_template[slot]")
      with_tag("input#item_template_max_stack[name=?]", "item_template[max_stack]")
      with_tag("textarea#item_template_extra[name=?]", "item_template[extra]")
    end
  end
end
