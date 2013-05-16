require 'spec_helper'

describe Follow do

  describe Follow::UserMethods do
    let(:user1) {FactoryGirl.create :user}
    let(:user2) {FactoryGirl.create :user}

    describe '#follow_by_user' do
      context 'user1 follows user2'do
        subject {user2.follow_by_user user1}

        it 'adds user2 to user1\'s following list' do
          expect {subject}.to change {user1.followings.count}.by(1)
        end

        it 'adds user1 to user2\'s followers' do
          expect {subject}.to change {user2.followers.count}.by(1)
        end

        context 'when user try to follow him/herself' do
          subject {user2.follow_by_user user2}

          it 'won\'t be valid' do
            expect {subject}.to raise_error {ActiveRecord::RecordInvalid}
          end
        end
      end
    end

    describe '#unfollow_by_user' do
      context 'user1 unfollows user2' do
        subject {user2.unfollow_by_user user1}

        context 'when user1 is not following user2' do
          before {user1.forward_follows.destroy_all}

          it {should be false}
        end

        context 'when user1 is following user2' do
          before {user2.follow_by_user user1}

          it 'removes user2 from user1\'s following list' do
            expect {subject}.to change {user1.followings.count}.by(-1)
          end

          it 'removes user1 from user2\'s followers' do
            expect {subject}.to change {user2.followers.count}.by(-1)
          end

          it {should be true}
        end
      end
    end
  end
end
