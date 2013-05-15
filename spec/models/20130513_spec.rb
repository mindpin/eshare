require 'spec_helper'

describe '测试FileEntity构造' do
  before {
    @file = File.new('README.md')
    @file_entity = FileEntity.create :attach => @file
  }

  it {
    p @file_entity.attach.path
    @file_entity.attach.path.should_not be_blank
  }

  it {
    p @file_entity.attach.path
    p @file.path
    File.new(@file_entity.attach.path).size.should == @file.size
  }
end