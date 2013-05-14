require 'spec_helper'

describe "/drops/edit.html.erb" do
  include DropsHelper

  before(:each) do
    assigns[:drop] = @drop = stub_model(Drop,
      :new_record? => false,
      :npc_id => 1,
      :item_template_id => 1,
      :quantity => 1,
      :probability => 1
    )
  end

  it "renders the edit drop form" do
    render

    response.should have_tag("form[action=#{drop_path(@drop)}][method=post]") do
      with_tag('input#drop_npc_id[name=?]', "drop[npc_id]")
      with_tag('input#drop_item_template_id[name=?]', "drop[item_template_id]")
      with_tag('input#drop_quantity[name=?]', "drop[quantity]")
      with_tag('input#drop_probability[name=?]', "drop[probability]")
    end
  end
end
