require "spec_helper"

describe Course do
  
  describe "不指定 inhouse_kind" do
    before {
      @course = FactoryGirl.create(:course)
    }

    it "course 对象存在" do
      @course.nil?.should == false
    end

    it "inhouse_kind 为空" do
      @course.inhouse_kind.should == nil
    end
  end

  describe "指定正确 inhouse_kind" do
    before {
      @inhouse_course = FactoryGirl.create(:course, :inhouse_kind => COURSE_INHOUSE_KINDS[0])
    }

    it "course 对象存在" do
      @course.nil?.should == false
    end

    it "inhouse_kind 不为空" do
      @inhouse_course.inhouse_kind.should == COURSE_INHOUSE_KINDS[0]
    end
  end

  describe "指定错误 inhouse_kind" do
    before {
      @inhouse_course = FactoryGirl.create(:course, :inhouse_kind => 'test')
    }

    it "course 对象不存在" do
      @course.nil?.should == true
    end
  end

end