require 'spec_helper'

describe TagFollow do
  before{
    @tag_1 = FactoryGirl.create :tag
    @tag_2 = FactoryGirl.create :tag

    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
  }

  it{
    @tag_1.follow_users.should == []
  }

  it{
    @user_1.follow_tags.should == []
  }

  context 'follow' do
    before{
      @user_1.follow @tag_1
      @user_2.follow @tag_1

      @user_1.follow @tag_2
    }

    it{
      @tag_1.follow_users.should == [@user_2, @user_1]
    }

    it{
      @tag_2.follow_users.should == [@user_1] 
    }

    it{
      @user_1.follow_tags.should == [@tag_2, @tag_1]
    }

    it{
      @user_2.follow_tags.should == [@tag_1]
    }

    context 'unfollow' do
      before{
        @user_1.unfollow @tag_1
      }

      it{
        @tag_1.reload
        @tag_1.follow_users.should == [@user_2]
      }

      it{
        @tag_2.reload
        @tag_2.follow_users.should == [@user_1] 
      }

      it{
        @user_1.reload
        @user_1.follow_tags.should == [@tag_2]
      }

      it{
        @user_2.reload
        @user_2.follow_tags.should == [@tag_1]
      }
    end
  end
end