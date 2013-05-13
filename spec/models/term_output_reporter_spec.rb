require "spec_helper"

describe TermOutputReporter do
  describe "#ansi_to_html" do
    let(:reporter) {TermOutputReporter.new("")}
    let(:ansi1) {"\e[38;5;196mFoo"}
    let(:html1) {"<span style='color:white;'>Foo</span><br />"}
    let(:ansi2) {"\e[31mBar"}
    let(:html2) {"<span style='color:red;'>Bar</span><br />"}
    let(:ansi3) {"Baz"}
    let(:html3) {"<span style='color:white;'>Baz</span><br />"}

    it "converts ansi1 to html1" do
      reporter.ansi_to_html(ansi1).should eq html1
    end

    it "converts ansi2 to html2" do
      reporter.ansi_to_html(ansi2).should eq html2
    end

    it "converts ansi3 to html3" do
      reporter.ansi_to_html(ansi3).should eq html3
    end
  end

  describe "#run" do
    let(:reporter) {TermOutputReporter.new("echo '\e[31mHello'")}
    let(:message)  {{:output => "<span style='color:red;'>Hello</span><br />"}}
    before {FayeClient.stub(:publish)}

    it "sends converted terminal output to a faye channel" do
      FayeClient.should_receive(:publish).with("/cmd/#{reporter.job_id}", message)
      reporter.run
    end
  end
end
