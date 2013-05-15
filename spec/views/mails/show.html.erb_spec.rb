# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/mails/show.html.erb" do
  include MailsHelper
  before(:each) do
    assigns[:mail] = @mail = stub_model(Mail,
      :owner_id => 1,
      :send_id => 1,
      :recipient_id => 1,
      :content => "value for content",
      :read => false,
      :attachment => "value for attachment"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ content/)
    response.should have_text(/false/)
    response.should have_text(/value\ for\ attachment/)
  end
end
