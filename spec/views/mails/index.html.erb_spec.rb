require 'spec_helper'

describe "/mails/index.html.erb" do
  include MailsHelper

  before(:each) do
    assigns[:mails] = [
      stub_model(Mail,
        :owner_id => 1,
        :send_id => 1,
        :recipient_id => 1,
        :content => "value for content",
        :read => false,
        :attachment => "value for attachment"
      ),
      stub_model(Mail,
        :owner_id => 1,
        :send_id => 1,
        :recipient_id => 1,
        :content => "value for content",
        :read => false,
        :attachment => "value for attachment"
      )
    ]
  end

  it "renders a list of mails" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for content".to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
    response.should have_tag("tr>td", "value for attachment".to_s, 2)
  end
end
