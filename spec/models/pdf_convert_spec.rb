require 'spec_helper'
require 'sidekiq/testing/inline'

describe PDFConvert do
  describe '#convert' do
    let(:rghost)    {double()}
    let(:converter) {PDFConvert.new('./a/fake/path/fake.pdf', './another/fake/path/fake.png')}
    before do
      RGhost::Convert.stub(:new).and_return rghost
      FileUtils.stub(:mkdir_p)
      FileUtils.stub(:rm)
    end
    
    it 'converts pdf to png images' do
      rghost.should_receive(:to).with(:png, an_instance_of(Hash))
      converter.convert
    end
  end
end
