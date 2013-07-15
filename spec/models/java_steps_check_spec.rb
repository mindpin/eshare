
# 这个测试用到 java_step_tester server travis 上没有办法测试
# 所以注释掉，需要时解除注释单独跑
require 'spec_helper'
describe JavaStep do

  before {
    @course_ware_1 = FactoryGirl.create(:course_ware, :kind => 'java')
    @user = FactoryGirl.create(:user)
  }

  it{
    rule = %`
      @Test
      public void test_1() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(3,a.sum(1, 2));
      }

      @Test
      @TestDescription("sum(3, 4) -> 7")
      public void test_2() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(7,a.sum(3, 4));
      }
    `
    step = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule)
    input = %`
      public int sum(int a, int b){
        return a + b;
      }
    `
    json = step.check(input,@user)
    hash = JSON.parse(json)
    hash.should == {
      "error"   => "",
      "success" => true,
      "assets"  => [
        {
          "test_description" => "test_1",
          "result"           => true,
          "exception"        => ""
          
        },
        {
          "test_description" => "sum(3, 4) -> 7",
          "result"           => true,
          "exception"        => ""
        }
      ]
    }

  }

  it{
    rule = %`
      @Test
      public void test_1() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(1, 2));
      }

      @Test
      public void test_2() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input = %`
      public int sum(int a, int b){
        return a + b;
      }
    `

    step = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule)
    json = step.check(input,@user)
    hash = JSON.parse(json)

    hash.should == {
      "error"   => "",
      "success" => false,
      "assets"  => [
        {
            "test_description" => "test_1",
            "result"           => false,
            "exception"        => ""
        },
        {
            "test_description" => "test_2",
            "result"           => true,
            "exception"        => ""
        }
      ]
    }

  }

  it{
    rule = %`
      @Test
      public void test_1() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(2, 2));
      }

      @Test
      public void test_2() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input = %`
      public int sum(int a, int b){
        int i = 1/(a-b);
        return a + b;
      }
    `

    step = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule)
    json = step.check(input,@user)
    hash = JSON.parse(json)
    hash.should == {
      "error"   => "",
      "success" => false,
      "assets"  => [
        {
            "test_description" => "test_1",
            "result"           => false,
            "exception"        => "java.lang.ArithmeticException: / by zero"
        },
        {
            "test_description" => "test_2",
            "result"           => true,
            "exception"        => ""
        }
      ]
    }

  }

  it{
    rule = %`
      @Test
      public void test_1() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(2, 2));
      }

      @Test
      public void test_2() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input = %`
      public int sum(int a, int b){
        abc
        return a + b;
      }
    `

    step = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule)
    json = step.check(input,@user)
    hash = JSON.parse(json)
    hash.should == {
      "error"   => "代码编译异常",
      "success" => false,
      "assets"  => []
    }

  }

  it{
    rule = %`
      @Test
      public void test_1() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(2, 2));
      }

      @Test
      public void test_2() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input = %`
      public int sum(int a, int b){
        init i = 1/1;
        return a + b;
      }
    `

    step = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule)
    json = step.check(input,@user)
    hash = JSON.parse(json)
    hash.should == {
      "error"   => "代码编译异常",
      "success" => false,
      "assets"  => []
    }

  }

  it{
    rule = %`
      @Test
      public void test_1() {
        RuleTest a = new RuleTest();
        Assert.assertEquals(4,a.sum(2, 2));
      }
      abcdef
      @Test
      public void test_2() {
        abc
        RuleTest a = new RuleTest();
        Assert.assertEquals(5,a.sum(2, 3));
      }
    `

    input = %`
      public int sum(int a, int b){
        return a + b;
      }
    `

    step = FactoryGirl.create(:java_step, :course_ware => @course_ware_1, :rule => rule)
    json = step.check(input,@user)
    hash = JSON.parse(json)
    hash.should == {
      "error"   => "代码编译异常",
      "success" => false,
      "assets"  => []
    }

  }
end