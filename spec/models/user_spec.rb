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
end