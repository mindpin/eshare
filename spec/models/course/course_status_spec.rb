require "spec_helper"

describe Course do
  describe '新创建的 course 的 status' do
    before{
      @user = FactoryGirl.create(:user)
      @course = Course.create!(:name => "name", :cid => randstr, :creator => @user)
    }

    it{
      @course.status.should == 'UNPUBLISHED'
    }

    it{
      course_1 = Course.create(:name => "name", :cid => randstr, :creator => @user, :status => 'xxx')
      course_1.id.should == nil
    }
  end

  describe 'scope' do
    before{
      @user = FactoryGirl.create(:user)
      @course_1 = Course.create!(:name => "1", :cid => randstr, :creator => @user, :status => Course::STATUS_UNPUBLISHED)
      @course_2 = Course.create!(:name => "1", :cid => randstr, :creator => @user, :status => Course::STATUS_PUBLISHED)
      @course_3 = Course.create!(:name => "1", :cid => randstr, :creator => @user, :status => Course::STATUS_MAINTENANCE)
    }

    it{
      @course_1.status.should == 'UNPUBLISHED'
      @course_2.status.should == 'PUBLISHED'
      @course_3.status.should == 'MAINTENANCE'
    }

    it{
      Course.unpublished.should =~ [@course_1]
      Course.published.should   =~ [@course_2]
      Course.maintenance        =~ [@course_3]
      Course.published_and_maintenance =~ [@course_2, @course_3]
    }
  end
end