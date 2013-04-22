require "spec_helper"

describe User do
  describe '用户邮箱校验' do
    before {
      @user1 = User.new :login => 'jerry',
                       :email => 'aaa',
                       :password => '1234',
                       :role => 'admin'

      @user2 = User.new :login => 'jerry',
                       :email => 'a@b.com',
                       :password => '1234',
                       :role => 'admin'

      @user1.save
      @user2.save
    }

    it {
      User.count.should == 1      
    }

    it {
      User.all.last.should == @user2
    }

    it {
      @user1.errors.count.should == 1
    }

    it {
      @user1.errors.first[0].should == :email
    }

    it 'email should invalid' do
      @user1.errors.first[1].
        should == I18n.t("activerecord.errors.models.user.attributes.email.invalid")
    end

    it {
      @user2.errors.count.should == 0
    }
  end

  describe 'CreateActivitie' do
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

      context '传入正确数据' do
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
end