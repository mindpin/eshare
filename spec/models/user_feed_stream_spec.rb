require 'spec_helper'

describe UserFeedStream do
  describe 'db' do
    let(:user1) {FactoryGirl.create :user}
    let(:user2) {FactoryGirl.create :user}
    let(:user3) {FactoryGirl.create :user}
    let(:user_timeline) {user1.user_timeline}
    let(:home_timeline) {user1.home_timeline}

    before do
      user1.follow user2
      8.times {FactoryGirl.create :feed, :who => user1}
      8.times {FactoryGirl.create :feed, :who => user2}
      8.times {FactoryGirl.create :feed, :who => user3}
    end

    describe '#user_timeline' do
      subject {user_timeline}

      its(:first) {should be_a MindpinFeeds::Feed}

      context 'only contains user1\'s feeds' do
        let(:users) {user_timeline.map(&:who).uniq}
        subject {users}

        it {should eq [user1]}
      end
    end

    describe '#home_timeline' do
      subject {home_timeline}

      its(:first) {should be_a MindpinFeeds::Feed}

      context 'only contains user1\'s feeds' do
        let(:users) {home_timeline.map(&:who).uniq}
        subject {users}

        it {should =~ [user1, user2]}
      end
    end
  end

  describe 'user._make_where_for_since_and_max_id' do
    before {
      @user = FactoryGirl.create :user
    }

    it {
      @user._make_where_for_since_and_max_id(nil, nil).should == 'TRUE'
    }

    it {
      @user._make_where_for_since_and_max_id(100, nil).should == 'feeds.id > 100'
    }

    it {
      @user._make_where_for_since_and_max_id(nil, 300).should == 'feeds.id <= 300'
    }

    it {
      @user._make_where_for_since_and_max_id(200, 400).should == 'feeds.id > 200 AND feeds.id <= 400'
    }
  end

  describe 'home_timeline 的分页' do
    before {
      @user = FactoryGirl.create :user
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
      @user3 = FactoryGirl.create :user
      @user4 = FactoryGirl.create :user
      @user5 = FactoryGirl.create :user

      [@user, @user1, @user2, @user3, @user4, @user5].each do |user|
        8.times {FactoryGirl.create :feed, :who => user}
      end

      [@user1, @user2, @user3, @user4, @user5].each do |user|
        @user.follow user
      end
    }

    it {
      @user.home_timeline.count.should == 20
    }

    it {
      @user.home_timeline(:count => 7).count.should == 7
    }

    it {
      # 总共48条
      @user.home_timeline(:count => 40, :page => 2).count.should == 8
    }

    it {
      max_id = @user.home_timeline(:count => 30).last.id
      @user.home_timeline(:max_id => max_id).count.should == 19
    }

    it {
      since_id = @user.home_timeline(:count => 20).last.id
      @user.home_timeline(:since_id => since_id).count.should == 19
    }

    it {
      max_id = @user.home_timeline(:count => 10).last.id
      since_id = @user.home_timeline(:count => 20).last.id
      @user.home_timeline(:since_id => since_id, :max_id => max_id).count.should == 10
    }
  end

  describe 'user_timeline 的分页' do
    before {
      @user = FactoryGirl.create :user
      40.times {
        FactoryGirl.create :feed, :who => @user
      }
    }

    it {
      @user.user_timeline.count.should == 20
    }

    it {
      @user.user_timeline(:count => 7).count.should == 7
    }

    it {
      # 总共48条
      @user.user_timeline(:count => 30, :page => 2).count.should == 10
    }

    it {
      max_id = @user.user_timeline(:count => 30).last.id
      @user.user_timeline(:max_id => max_id).count.should == 11
    }

    it {
      since_id = @user.user_timeline(:count => 20).last.id
      @user.user_timeline(:since_id => since_id).count.should == 19
    }

    it {
      max_id = @user.user_timeline(:count => 10).last.id
      since_id = @user.user_timeline(:count => 20).last.id
      @user.user_timeline(:since_id => since_id, :max_id => max_id).count.should == 10
    }
  end
end
