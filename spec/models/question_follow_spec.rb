require "spec_helper"

describe QuestionFollow do
  


  describe "问题创建者" do 
    before {
      @creator      = FactoryGirl.create :user
      @question     = FactoryGirl.create(:question, :creator => @creator)
    }

    it "问题有被自己关注" do
      @question.followed_by?(@creator).should == true
    end

    it {
      @question.last_view_time_of(@creator).should_not == nil
    }

    it {
      @question.follow_users.should == [@creator]
    }

    it {
      @creator.follow_questions.should == [@question]
    }

    context '取消关注' do
      before{
        @question.unfollow_by_user(@creator)
      }

      it {
        @question.follow_users.should == []
      }

      it {
        @creator.follow_questions.should == []
      }

      it{
        @question.followed_by?(@creator).should == false
      }

    end

  end


  describe "其它用户" do

    before {
      @user         = FactoryGirl.create :user
      @question     = FactoryGirl.create(:question)
    }

    it {
      @question.followed_by?(@user).should == false
    }

    context 'follow_by_user' do
      before{
        @question.follow_by_user(@user)
      }

      it{
        @question.follow_users.should == [@user, @question.creator]
      }

      it{
        @user.follow_questions.should == [@question]
      }

      it{
        @question.followed_by?(@user).should == true
      }

      it "查看记录时间" do
        last_view_time = @question.last_view_time_of(@user)

        Timecop.travel(Time.now + 1.seconds) do
          @question.visit_by!(@user)
        end

        @question.last_view_time_of(@user).should > last_view_time
      end
    end


  end


  
end