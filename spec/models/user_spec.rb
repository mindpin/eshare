require "spec_helper"

describe User do
  describe '用户邮箱校验' do
    before {
      # 邮箱不正确
      @user1 = User.new :login => 'jerry',
                        :name =>'zhangsan',
                        :email => 'aaa',
                        :password => '1234',
                        :role => 'admin'

      # 正确
      @user2 = User.new :login => 'jerry',
                        :name =>'lisi',
                        :email => 'a@b.com',
                        :password => '1234',
                        :role => 'admin'

      # login == email 正确
      @user3 = User.new :login => 'ben7th@126.com',
                        :name => '宋亮',
                        :email => 'ben7th@126.com',
                        :password => '1234',
                        :role => 'student'

      # login != email 不正确
      @user4 = User.new :login => 'ben7th@gmail.com',
                        :name => '宋亮',
                        :email => 'ben7th@126.com',
                        :password => '1234',
                        :role => 'student'
    }

    it {
      @user1.should_not be_valid
    }

    it {
      @user2.should be_valid
    }

    it {
      @user3.should be_valid
    }

    it {
      @user4.should_not be_valid
    }

    it {
      @user1.save
      @user2.save
      @user3.save
      @user4.save

      User.count.should == 2
      User.all.should =~ [@user2, @user3]
    }

    it {
      @user1.valid?
      @user1.errors.count.should == 1
      @user1.errors.first[0].should == :email
    }

    it 'email should invalid' do
      @user1.valid?
      @user1.errors.first[1].
        should == I18n.t("activerecord.errors.models.user.attributes.email.invalid")
    end

    it {
      @user2.valid?
      @user2.errors.count.should == 0
    }

    it {
      @user3.valid?
      @user3.errors.count.should == 0
    }

    it {
      @user4.valid?
      @user4.errors.count.should == 1
      @user4.errors.first[0].should == :login
    }
  end
end