require 'spec_helper'

describe AttrsConfig do
  describe '.get' do
    subject      {AttrsConfig.get(:test_attrs)}
    let(:fields) {{:string_field => :string, :boolean_field => :boolean}}
    before do
      fields.each do |field, field_type|
        FactoryGirl.create(:attrs_config, :role => :student, :field => field, :field_type => field_type)
      end
    end

    it {should eq fields}
  end
end
