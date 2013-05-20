require 'spec_helper'

describe UserFeedStream do
  describe 'db' do
    let(:user1) {FactoryGirl.create :user}
    let(:user2) {FactoryGirl.create :user}
    let(:homeline_db) {user1.homeline_db}
    let(:timeline_db) {user1.timeline_db}

    before do
      user1.follow user2
      8.times {FactoryGirl.create :feed, :who => user1}
      8.times {FactoryGirl.create :feed, :who => user2}
    end

    describe '#homeline_db' do
      subject {homeline_db}

      its(:first) {should be_a MindpinFeeds::Feed}

      context 'only contains user1\'s feeds' do
        let(:users) {homeline_db.map(&:who).uniq}
        subject {users}

        it {should eq [user1]}
      end
    end

    describe '#timeline_db' do
      subject {timeline_db}

      its(:first) {should be_a MindpinFeeds::Feed}

      context 'only contains user1\'s feeds' do
        let(:users) {timeline_db.map(&:who).uniq}
        subject {users}

        it {should =~ [user1, user2]}
      end
    end
  end

  describe 'redis' do
    it{
      user1 = FactoryGirl.create :user
      user2 = FactoryGirl.create :user

      user1.homeline.should == []
      user1.timeline.should == []

      user1.follow user2
      Timecop.travel(Time.now - 4.seconds) do
        @feed1 = FactoryGirl.create :feed, :who => user1
      end
      Timecop.travel(Time.now - 3.seconds) do
        @feed12 = FactoryGirl.create :feed, :who => user1
      end
      Timecop.travel(Time.now - 2.seconds) do
        @feed2 = FactoryGirl.create :feed, :who => user2
      end
      Timecop.travel(Time.now - 1.seconds) do
        @feed22 = FactoryGirl.create :feed, :who => user2
      end

      user1.homeline.should == [@feed12, @feed1]
      user1.timeline.should == [@feed22, @feed2, @feed12, @feed1]
    }
  end
end
