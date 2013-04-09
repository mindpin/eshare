require 'spec_helper'

describe FileEntity do
  context 'self.content_kind' do
    before {
      @file_entity = FactoryGirl.create :file_entity, :attach_file_name => '123.jpg'
      @file_entity_ppt = FactoryGirl.create :file_entity, :attach_file_name => 'demo.ppt'
    }

    it {
      @file_entity.content_kind.should == :image
    }

    it {
      @file_entity.is_image?.should == true
    }

    it {
      @file_entity_ppt.content_kind.should == :ppt
    }

    it {
      @file_entity_ppt.is_ppt?.should == true
    }
  end
end