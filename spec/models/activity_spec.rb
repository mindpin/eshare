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

  let(:hash_true_no_end_time) {
    {
      :title      => 'title1',
      :content    => 'content1',
      :start_time => Time.now + 2.day
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

  describe '#creater' do
    context '传入正确数据' do
      it {
        expect{
          creator.activities.create(hash_true)
        }.to change{
          creator.activities.count
        }.by(1)
      }

      it {
        expect{
          creator.activities.create(hash_true_no_end_time)
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

  describe '#end!' do
    let(:no_end_time_activity) { creator.activities.create(hash_true_no_end_time) }
    let(:end_time_activity) { creator.activities.create(hash_true) }
    context '没有结束时间' do
      it{
        expect{
          no_end_time_activity.end!
        }.to change{
          no_end_time_activity.status
        }.from('PREP').to('END')
      }
    end

    context '有结束时间' do
      it{
        expect{
          end_time_activity.end!
        }.to_not change{
          end_time_activity.status
        }
      }
    end
  end

  describe '#refresh_status!' do
    context 'Time.now < start_time' do
      before do
        @hash = {
                  :title      => 'title1',
                  :content    => 'content1',
                  :start_time => Time.now + 2.day,
                  :end_time   => Time.now + 5.day
                }
        @activity = creator.activities.create(@hash)
      end
      it{
        expect{
          @activity.refresh_status!
        }.to_not change{
          @activity.status
        }
      }
    end

    context 'Time.now < end_time' do
      before do
        Timecop.travel(Time.now - 3.day) do
          @hash = {
                    :title      => 'title1',
                    :content    => 'content1',
                    :start_time => Time.now + 2.day,
                    :end_time   => Time.now + 5.day
                  }
          @activity = creator.activities.create(@hash)
        end
      end
      it{
        expect{
          @activity.refresh_status!
        }.to change{
          @activity.status
        }.from('PREP').to('BEGIN')
      }
    end

    context 'Time.now > end_time' do
      before do
        Timecop.travel(Time.now - 6.day) do
          @hash = {
                    :title      => 'title1',
                    :content    => 'content1',
                    :start_time => Time.now + 2.day,
                    :end_time   => Time.now + 5.day
                  }
          @activity = creator.activities.create(@hash)
        end
      end
      it{
        expect{
          @activity.refresh_status!
        }.to change{
          @activity.status
        }.from('PREP').to('END')
      }
    end
  end
end