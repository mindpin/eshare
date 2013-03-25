require 'spec_helper'
require 'sidekiq/testing/inline'

describe PPTConverter do
  let(:file) {FactoryGirl.create :file_entity}

  it 'converts ppt to swf in background' do
    Odocuconv::Converter.any_instance.should_receive(:start)
    Odocuconv::Converter.any_instance.should_receive(:convert).with(an_instance_of(String), an_instance_of(String))
    Odocuconv::Converter.any_instance.should_receive(:stop)
    PPTConverter.perform_async(file.id)
  end
end
