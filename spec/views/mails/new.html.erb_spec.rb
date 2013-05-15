# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "/mails/new.html.erb" do
  include MailsHelper

  before(:each) do
    assigns[:mail] = stub_model(Mail,
      :new_record? => true,
      :owner_id => 1,
      :send_id => 1,
      :recipient_id => 1,
      :content => "value for content",
      :read => false,
      :attachment => "value for attachment"
    )
  end

  it "renders new mail form" do
    render

    response.should have_tag("form[action=?][method=post]", mails_path) do
      with_tag("input#mail_owner_id[name=?]", "mail[owner_id]")
      with_tag("input#mail_send_id[name=?]", "mail[send_id]")
      with_tag("input#mail_recipient_id[name=?]", "mail[recipient_id]")
      with_tag("textarea#mail_content[name=?]", "mail[content]")
      with_tag("input#mail_read[name=?]", "mail[read]")
      with_tag("textarea#mail_attachment[name=?]", "mail[attachment]")
    end
  end
end
