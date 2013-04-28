require 'spec_helper'

describe Course do
  describe ".parse_tudou_list" do
    let(:url) {"http://www.tudou.com/plcover/P4ZWE5e2Zwg/"}
    let(:pattern) {/^http:\/\/www\.tudou\.com\/plcover\/\w*$/}
    subject {Course.parse_tudou_list url}

    it {should be 2}
    its(:first) {should match pattern}
  end
end
