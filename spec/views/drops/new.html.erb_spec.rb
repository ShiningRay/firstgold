# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/drops/new.html.erb" do
  include DropsHelper

  before(:each) do
    assigns[:drop] = stub_model(Drop,
      :new_record? => true,
      :npc_id => 1,
      :item_template_id => 1,
      :quantity => 1,
      :probability => 1
    )
  end

  it "renders new drop form" do
    render

    response.should have_tag("form[action=?][method=post]", drops_path) do
      with_tag("input#drop_npc_id[name=?]", "drop[npc_id]")
      with_tag("input#drop_item_template_id[name=?]", "drop[item_template_id]")
      with_tag("input#drop_quantity[name=?]", "drop[quantity]")
      with_tag("input#drop_probability[name=?]", "drop[probability]")
    end
  end
end
