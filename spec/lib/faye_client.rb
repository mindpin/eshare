require "spec_helper"

describe FayeClient do
  describe ".publish" do
    let(:channel) {"/dummy_channel"}
    let(:params)  {{:data => "dummy data"}}
    let(:message) {{:message => {:channel => channel, :data => params}.to_json}}
    let(:uri)     {URI.parse "http://127.0.0.1:8080/faye"}
    before {stub_const("Net::HTTP", double())}
    
    it "polls message to faye server" do
      Net::HTTP.should_receive(:post_form).with(uri, message)
      FayeClient.publish channel, params
    end
  end
end
