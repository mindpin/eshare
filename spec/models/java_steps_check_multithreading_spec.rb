=begin
# 这个测试用到 java_step_tester server travis 上没有办法测试
# 所以注释掉，需要时解除注释单独跑
require 'spec_helper'
describe JavaStep do

  before {
    @course_ware_1 = FactoryGirl.create(:course_ware, :kind => 'java')
    @user = FactoryGirl.create(:user)


    rule_1 = %`
      @Test
      public void test_11() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(3,a.sum(1, 2));
      }

      @Test
      @TestDescription("sum(3, 4) -> 7")
      public void test_12() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(7,a.sum(3, 4));
      }
    `
    input_1 = %`
      public int sum(int a, int b){
        return a + b;
      }
    `
    result_1 = {
      "error"   => "",
      "success" => true,
      "assets"  => [
        {
          "test_description" => "sum(3, 4) -> 7",
          "result"           => true,
          "exception"        => ""
        },
        {
          "test_description" => "test_11",
          "result"           => true,
          "exception"        => ""
          
        }
      ]
    }

    rule_2 = %`
      @Test
      public void test_21() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(1, 2));
      }

      @Test
      public void test_22() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input_2 = %`
      public int sum(int a, int b){
        return a + b;
      }
    `
    result_2 = {
      "error"   => "",
      "success" => false,
      "assets"  => [
        {
            "test_description" => "test_22",
            "result"           => true,
            "exception"        => ""
        },
        {
            "test_description" => "test_21",
            "result"           => false,
            "exception"        => ""
        }
      ]
    }


    rule_3 = %`
      @Test
      public void test_31() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(2, 2));
      }

      @Test
      public void test_32() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input_3 = %`
      public int sum(int a, int b){
        int i = 1/(a-b);
        return a + b;
      }
    `

    result_3 = {
      "error"   => "",
      "success" => false,
      "assets"  => [
        {
            "test_description" => "test_32",
            "result"           => true,
            "exception"        => ""
        },
        {
            "test_description" => "test_31",
            "result"           => false,
            "exception"        => "java.lang.ArithmeticException: / by zero"
        }
      ]
    }


    rule_4 = %`
      @Test
      public void test_41() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(2, 2));
      }

      @Test
      public void test_42() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input_4 = %`
      public int sum(int a, int b){
        abc
        return a + b;
      }
    `

    result_4 = {
      "error"   => "代码编译异常",
      "success" => false,
      "assets"  => []
    }

    rule_5 = %`
      @Test
      public void test_51() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(2, 2));
      }

      @Test
      public void test_52() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input_5 = %`
      public int sum(int a, int b){
        init i = 1/1;
        return a + b;
      }
    `

    result_5 = {
      "error"   => "代码编译异常",
      "success" => false,
      "assets"  => []
    }


    rule_6 = %`
      @Test
      public void test_61() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(2, 2));
      }
      abcdef
      @Test
      public void test_62() {
        abc
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input_6 = %`
      public int sum(int a, int b){
        return a + b;
      }
    `

    result_6 = {
      "error"   => "代码编译异常",
      "success" => false,
      "assets"  => []
    }

    step_1 = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule_1)
    step_2 = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule_2)
    step_3 = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule_3)
    step_4 = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule_4)
    step_5 = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule_5)
    step_6 = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule_6)

    @rules = [rule_1, rule_2, rule_3, rule_4, rule_5, rule_6]
    @inputs = [input_1, input_2, input_3, input_4, input_5, input_6]
    @results = [result_1, result_2, result_3, result_4, result_5, result_6]
    @steps = [step_1, step_2, step_3, step_4, step_5, step_6]


  }

  it{
    thxs = []
    0.upto(5) do |i|
      thxs << Thread.new{
        p ">>>>>>>>>  #{i}"
        hash = @steps[i].check(@inputs[i],@user)
        
        p "<<<<<<<<<<<<<< #{i} #{hash} #{hash == @results[i]}"
        hash.should == @results[i]
      }
    end
    thxs.each{|thx|thx.join}


  }

end
=end