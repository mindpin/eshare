require 'spec_helper'

describe JavaStep do

  before {
    @course_ware_1 = FactoryGirl.create(:course_ware, :kind => 'java')
    @course_ware_2 = FactoryGirl.create(:course_ware, :kind => 'java')

    @step_1_1 = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => "rule_1")
    @step_2_1 = FactoryGirl.create(:java_step, :course_ware => @course_ware_2, :rule => "rule_2")
    @step_1_2 = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => "rule_3")
    @step_2_2 = FactoryGirl.create(:java_step, :course_ware => @course_ware_2, :rule => "rule_4")
    @step_2_3 = FactoryGirl.create(:java_step, :course_ware => @course_ware_2, :rule => "rule_5")
  }

  describe "课件 1" do

    it "step_1_1 上一个步骤" do
      @step_1_1.prev.should == nil
    end

    it "step_1_1 下一个步骤" do
      @step_1_1.next.should == @step_1_2
    end

    it "step_1_2 上一个步骤" do
      @step_1_2.prev.should == @step_1_1
    end

    it "step_1_2 下一个步骤" do
      @step_1_2.next.should == nil
    end

  end

  describe "课件 2" do

    it "step_2_1 上一个步骤" do
      @step_2_1.prev.should == nil
    end

    it "step_2_1 下一个步骤" do
      @step_2_1.next.should == @step_2_2
    end

    it "step_2_2 上一个步骤" do
      @step_2_2.prev.should == @step_2_1
    end

    it "step_2_2 下一个步骤" do
      @step_2_2.next.should == @step_2_3
    end

    it "step_2_3 上一个步骤" do
      @step_2_3.prev.should == @step_2_2
    end

    it "step_2_3 下一个步骤" do
      @step_2_3.next.should == nil
    end

  end

  describe 'course_ware.total_count' do
    it{
      @course_ware_1.reload
      @course_ware_1.total_count.should == 2
    }

    it{
      @course_ware_2.reload
      @course_ware_2.total_count.should == 3
    }

    it{
      @step_2_3.destroy
      @course_ware_2.reload
      @course_ware_2.total_count.should == 2
    }

    it{
      FactoryGirl.create(:java_step, :course_ware => @course_ware_2, :rule => "rule_6")
      @course_ware_2.reload
      @course_ware_2.total_count.should == 4
    }
  end

  

end