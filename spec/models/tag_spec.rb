require 'spec_helper'

describe Tag do
  context '增加 avatar' do
    before{
      avatar = File.new(Rails.root.join(*%w[spec fixtures files cover.png]))
      @tag_1 = FactoryGirl.create :tag
      @tag_1.update_attributes(:avatar => avatar)
      @tag_1.reload
    }

    it{
      @tag_1.attributes["avatar"].should_not == nil
    }

    it{
      File.exists?(@tag_1.avatar.path).should == true
    }
  end
end