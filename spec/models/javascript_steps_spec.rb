require 'spec_helper'

describe JavascriptStep do

  before {
    @course_ware_1 = FactoryGirl.create(:course_ware, :kind => 'javascript')
    @course_ware_2 = FactoryGirl.create(:course_ware, :kind => 'javascript')

    @step_1_1 = @course_ware_1.javascript_steps.create(:content => "content_1", :rule => "rule_1")
    @step_2_1 = @course_ware_2.javascript_steps.create(:content => "content_2", :rule => "rule_2")
    @step_1_2 = @course_ware_1.javascript_steps.create(:content => "content_3", :rule => "rule_3")
    @step_2_2 = @course_ware_2.javascript_steps.create(:content => "content_4", :rule => "rule_4")
    @step_2_3 = @course_ware_2.javascript_steps.create(:content => "content_5", :rule => "rule_5")
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

  

end