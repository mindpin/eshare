require 'spec_helper'

describe AttrsConfig do
  describe '.get' do
    let(:fields) {{:string_field => :string, :boolean_field => :boolean}}
    subject      {AttrsConfig.get(:student)}
    before do
      fields.each do |field, field_type|
        FactoryGirl.create(:attrs_config, :role => :student, :field => field, :field_type => field_type)
      end
    end

    it {should eq fields}
  end
end
