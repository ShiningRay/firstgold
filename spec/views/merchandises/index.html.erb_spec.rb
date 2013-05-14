require 'spec_helper'

describe "/merchandises/index.html.erb" do
  include MerchandisesHelper

  before(:each) do
    assigns[:merchandises] = [
      stub_model(Merchandise,
        :item_id => 1,
        :price => 1,
        :limit => 1,
        :stock => 1,
        :name => "value for name",
        :description => "value for description",
        :shop_id => 1
      ),
      stub_model(Merchandise,
        :item_id => 1,
        :price => 1,
        :limit => 1,
        :stock => 1,
        :name => "value for name",
        :description => "value for description",
        :shop_id => 1
      )
    ]
  end

  it "renders a list of merchandises" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
