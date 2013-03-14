require 'spec_helper'

describe AttrsConfig do
  describe '.get' do
    subject      {AttrsConfig.get(:test_attrs)}
    let(:fields) {{:string_field => :string, :boolean_field => :boolean}}
    before       {FactoryGirl.create(:attrs_config)}

    it {should eq fields}
  end
end