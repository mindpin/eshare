require 'spec_helper'

describe UserFeedStream do
  let(:user1) {FactoryGirl.create :user}
  let(:user2) {FactoryGirl.create :user}
  let(:homeline) {user1.homeline}
  let(:timeline) {user1.timeline}

  before do
    user1.follow user2
    8.times {FactoryGirl.create :feed, :who => user1}
    8.times {FactoryGirl.create :feed, :who => user2}
  end

  describe '#homeline' do
    subject {homeline}

    its(:first) {should be_a MindpinFeeds::Feed}

    context 'only contains user1\'s feeds' do
      let(:users) {homeline.map(&:who).uniq}
      subject {users}

      it {should eq [user1]}
    end
  end

  describe '#timeline' do
    subject {timeline}

    its(:first) {should be_a MindpinFeeds::Feed}

    context 'only contains user1\'s feeds' do
      let(:users) {timeline.map(&:who).uniq}
      subject {users}

      it {should =~ [user1, user2]}
    end
  end
end
