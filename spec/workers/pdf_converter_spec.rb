require 'spec_helper'
require 'sidekiq/testing/inline'

describe PDFConverter do
  let(:file) {FactoryGirl.create :file_entity}
  let(:converter) {double()}
  before {PDFConvert.stub(:new).and_return converter}

  it 'converts pdf to png images in background' do
    converter.should_receive(:convert)
    PDFConverter.perform_async(file.id)
  end
end
