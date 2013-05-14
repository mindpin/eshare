require 'spec_helper'
require './script/makers/user_maker'

describe UserMaker do
  let(:user_maker) {UserMaker.new('teachers')}
  subject {user_maker}

  context 'instance methods' do
    describe '#produce' do
      let(:count) {user_maker.data.count}

      it 'produces users and their attached roles' do
        expect {user_maker.produce}.to change{User.count}.by(count)
      end
    end
  end
end
