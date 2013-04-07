require 'spec_helper'

describe Follow do
  describe Follow::UserMethods do
    describe '#follow' do
      let(:user1) {FactoryGirl.create :user}
      let(:user2) {FactoryGirl.create :user}

      context 'user1 follows user2'do
        subject {user1.follow user2}

        it 'adds user2 to user1\'s following list' do
          expect {subject}.to change {user1.followings.count}.by(1)
        end

        it 'adds user1 to user2\'s followers' do
          expect {subject}.to change {user2.followers.count}.by(1)
        end
      end

      context 'user1 unfollows user2' do
        subject {user1.unfollow user2}

        context 'when user1 is not following user2' do
          before {user1.forward_follows.destroy_all}

          it {should be false}
        end

        context 'when user1 is following user2' do
          before {user1.follow user2}

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
