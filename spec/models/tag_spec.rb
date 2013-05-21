require 'spec_helper'

describe Tag do
  context '增加 icon' do
    before{
      icon = File.new(Rails.root.join(*%w[spec fixtures files cover.png]))
      @tag_1 = FactoryGirl.create :tag
      @tag_1.update_attributes(:icon => icon)
      @tag_1.reload
    }

    it{
      @tag_1.attributes["icon"].should_not == nil
    }

    it{
      File.exists?(@tag_1.icon.path).should == true
    }
  end
end