require "spec_helper"

describe User do
  before {
    @current_inhouse = R::INHOUSE
    @current_internet = R::INTERNET

    R::INHOUSE = true
    R::INTERNET = false
  }

  after {
    R::INHOUSE = @current_inhouse
    R::INTERNET = @current_internet
  }

  describe '用户邮箱校验' do
    before {
      # 邮箱不正确
      @user1 = User.new :login => 'jerry',
                        :name =>'宋亮',
                        :email => 'aaa',
                        :password => '1234',
                        :role => 'admin'

      # 正确
      @user2 = User.new :login => 'jerry',
                        :name =>'李飞',
                        :email => 'a@b.com',
                        :password => '1234',
                        :role => 'admin'

      # login == email 正确
      @user3 = User.new :login => 'ben7th@126.com',
                        :name => '黄锴',
                        :email => 'ben7th@126.com',
                        :password => '1234',
                        :role => 'student'

      # login != email 不正确
      @user4 = User.new :login => 'ben7th@gmail.com',
                        :name => '吴笛',
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

describe 'internet user' do
  before {
    @current_inhouse = R::INHOUSE
    @current_internet = R::INTERNET

    R::INHOUSE = false
    R::INTERNET = true
  }

  after {
    R::INHOUSE = @current_inhouse
    R::INTERNET = @current_internet
  }

  describe '用户校验' do
    before {
      # 创建用户时，只需要填 password
      # password_confirmation 会自动被设置为一样
      @user1 = User.new :email => 'ben7th@sina.com',
                        :name =>'宋亮',
                        :password => '12345'

      @user2 = FactoryGirl.create :user
      @user2.password = '55577777'
    }

    it {
      @user1.valid?
      @user1.password_confirmation.should == '12345'
      @user1.login.should == 'ben7th@sina.com'
    }

    it {
      @user2.valid?
      @user2.password_confirmation.should_not == '55577777'
    }
  end
end