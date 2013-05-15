# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/shops/edit.html.erb" do
  include ShopsHelper

  before(:each) do
    assigns[:shop] = @shop = stub_model(Shop,
      :new_record? => false,
      :name => "value for name",
      :description => "value for description",
      :npc_id => 1
    )
  end

  it "renders the edit shop form" do
    render

    response.should have_tag("form[action=#{shop_path(@shop)}][method=post]") do
      with_tag('input#shop_name[name=?]', "shop[name]")
      with_tag('textarea#shop_description[name=?]', "shop[description]")
      with_tag('input#shop_npc_id[name=?]', "shop[npc_id]")
    end
  end
end
