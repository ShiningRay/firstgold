require 'spec_helper'

describe "/shops/new.html.erb" do
  include ShopsHelper

  before(:each) do
    assigns[:shop] = stub_model(Shop,
      :new_record? => true,
      :name => "value for name",
      :description => "value for description",
      :npc_id => 1
    )
  end

  it "renders new shop form" do
    render

    response.should have_tag("form[action=?][method=post]", shops_path) do
      with_tag("input#shop_name[name=?]", "shop[name]")
      with_tag("textarea#shop_description[name=?]", "shop[description]")
      with_tag("input#shop_npc_id[name=?]", "shop[npc_id]")
    end
  end
end
