require 'spec_helper'

describe Activity do
  let(:creator) {FactoryGirl.create :user}

  let(:hash_true) {
    {
      :title      => 'title1',
      :content    => 'content1',
      :start_time => Time.now + 2.day,
      :end_time   => Time.now + 4.day
    }
  }

  let(:hash_error) {
    {
      :title      => 'title1',
      :content    => 'content1',
      :start_time => Time.now + 4.day,
      :end_time   => Time.now + 2.day
    }
  }

  describe 'creater' do
    context '传入正确数据' do
      it {
        expect{
          creator.activities.create(hash_true)
        }.to change{
          creator.activities.count
        }.by(1)
      }
    end

    context '传入错误数据' do
      it {
        expect{
          creator.activities.create(hash_error)
        }.to change{
          creator.activities.count
        }.by(0)
      }
    end
  end
end