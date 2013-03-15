require 'spec_helper'

describe '#rename_duplicated_file_name' do
  let(:file_name1) {'a_text_file.txt'}
  let(:file_name2) {'a_text_file(1).txt'}
  let(:file_name3) {'a_text_file(2).txt'}
  let(:file_name4) {'a_text_file(3).txt'}

  it 'should add a incremental note to the duplicate file name' do
    rename_duplicated_file_name(file_name1).should eq file_name2
    rename_duplicated_file_name(file_name2).should eq file_name3
    rename_duplicated_file_name(file_name3).should eq file_name4
  end
end
