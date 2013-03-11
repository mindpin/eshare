require 'spec_helper'
require './script/makers/user_maker'

describe UserMaker do
  let(:user_maker) {UserMaker.load_yaml('teachers')}
  subject {user_maker}

  context 'class methods' do
    describe '.load_yaml' do
      it {should be_a UserMaker}
    end
  end

  context 'instance methods' do
    describe '#type' do
      its(:type) {should eq :teacher}
    end

    describe '#real_names' do
      its(:real_names) {should be_an Array}
    end

    describe '#produce' do
      let(:count) {user_maker.real_names.count}

      it 'produces users and their attached roles' do
        expect {user_maker.produce}.to change{[User.count, Teacher.count]}.from([0, 0]).to([count, count])
      end
    end
  end
end
