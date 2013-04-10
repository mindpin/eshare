require 'spec_helper'
require 'sidekiq/testing/inline'

describe PPTDocConverter do
  let(:file) {FactoryGirl.create :file_entity}
  let(:converter) {double()}
  before do
    Odocuconv::Converter.stub(:new).and_return converter
  end

  it 'converts ppt to swf in background' do
    converter.should_receive(:start)
    converter.should_receive(:convert).with(an_instance_of(String), an_instance_of(String))
    converter.should_receive(:stop)
    PPTDocConverter.perform_async(file.id)
  end
end
