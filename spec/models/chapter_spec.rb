require 'spec_helper'

describe Chapter do
  context 'validations' do
    subject {FactoryGirl.build :chapter}
    its(:save) {should be true}

    context 'title validation' do
      subject {FactoryGirl.build :chapter, :title => nil}
      its(:save) {should be false}
    end

    context 'creator validation' do
      subject {FactoryGirl.build :chapter, :creator => nil}
      its(:save) {should be false}
    end
  end
end
