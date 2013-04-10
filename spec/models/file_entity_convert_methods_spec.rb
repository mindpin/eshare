require 'spec_helper'

describe FileEntityConvertMethods do
  let(:entity) {FactoryGirl.build :file_entity}
  subject {entity.converter_dispatch}

  describe '#converter_dispatch' do
    context 'when entity is a ppt' do
      before {entity.attach_file_name = 'foo.ppt'}
      it {should be PPTDOCConverter}
    end

    context 'when entity is a doc' do
      before {entity.attach_file_name = 'foo.doc'}
      it {should be PPTDOCConverter}
    end

    context 'when entity is a pdf' do
      before {entity.attach_file_name = 'foo.pdf'}
      it {should be PDFConverter}
    end
  end
end
