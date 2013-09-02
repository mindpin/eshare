require 'spec_helper'
require 'sidekiq/testing'

describe CourseWareConverter do
  let(:file) {FactoryGirl.create :file_entity}
  before do
    Docsplit.stub(:extract_images).and_return ['haha.format']
  end

  it 'converts course ware to corresponding formats in background' do
    Docsplit.should_receive(:extract_images).with(an_instance_of(String), an_instance_of(Hash))
    CourseWareConverter.perform_async(file.id)
    CourseWareConverter.drain
  end
end
