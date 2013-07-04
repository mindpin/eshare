require "spec_helper"

describe Course do
  
  describe "不指定 inhouse_kind" do
    before {
      @course = FactoryGirl.create(:course)
    }

    it "course 对象存在" do
      @course.valid?.should == true
    end

    it "inhouse_kind 为空" do
      @course.inhouse_kind.should be_blank
    end
  end

  describe "指定正确 inhouse_kind" do
    before {
      @kind = COURSE_INHOUSE_KINDS.sample
      @course = FactoryGirl.create(:course, :inhouse_kind => @kind)
    }

    it "course 对象存在" do
      @course.valid?.should == true
    end

    it "inhouse_kind 不为空" do
      @course.inhouse_kind.should == @kind
    end
  end

  describe "指定错误 inhouse_kind" do

    it "course 对象不存在" do
      expect {
        @course = FactoryGirl.create(:course, :inhouse_kind => 'test')
      }.to raise_error(Exception)

      @course.nil?.should == true 
    end
  end

end