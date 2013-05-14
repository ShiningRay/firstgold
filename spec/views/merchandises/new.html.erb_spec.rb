require 'spec_helper'

describe "/merchandises/new.html.erb" do
  include MerchandisesHelper

  before(:each) do
    assigns[:merchandise] = stub_model(Merchandise,
      :new_record? => true,
      :item_id => 1,
      :price => 1,
      :limit => 1,
      :stock => 1,
      :name => "value for name",
      :description => "value for description",
      :shop_id => 1
    )
  end

  it "renders new merchandise form" do
    render

    response.should have_tag("form[action=?][method=post]", merchandises_path) do
      with_tag("input#merchandise_item_id[name=?]", "merchandise[item_id]")
      with_tag("input#merchandise_price[name=?]", "merchandise[price]")
      with_tag("input#merchandise_limit[name=?]", "merchandise[limit]")
      with_tag("input#merchandise_stock[name=?]", "merchandise[stock]")
      with_tag("input#merchandise_name[name=?]", "merchandise[name]")
      with_tag("textarea#merchandise_description[name=?]", "merchandise[description]")
      with_tag("input#merchandise_shop_id[name=?]", "merchandise[shop_id]")
    end
  end
end
