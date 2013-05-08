# -*- coding: utf-8 -*-
require "spec_helper"

describe Notifier do
  let(:user1)   {FactoryGirl.create :user}
  let(:user2)   {FactoryGirl.create :user}
  let(:channel) {"/users/#{user2.id}"}
  let(:message) {{:type => "short_message", :count => 1}}
  before        {stub_const("FayeClient", double())}

  it "sends message to front end after model creation" do
    FayeClient.should_receive(:publish).with(channel, message)
    user1.send_message "站内信！", user2
  end
end
