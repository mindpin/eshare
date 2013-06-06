require 'spec_helper'

describe StepHistory do
  before{
    @user_1  = FactoryGirl.create(:user)
    @user_2  = FactoryGirl.create(:user)
    @user_3  = FactoryGirl.create(:user)

    @course_ware_1 = FactoryGirl.create(:course_ware)
    @course_ware_2 = FactoryGirl.create(:course_ware)

    @jstep_1_1 = FactoryGirl.create(:javascript_step, :course_ware => @course_ware_1)
    @jstep_1_2 = FactoryGirl.create(:javascript_step, :course_ware => @course_ware_1)
    @jstep_1_3 = FactoryGirl.create(:javascript_step, :course_ware => @course_ware_1)
    @jstep_1_4 = FactoryGirl.create(:javascript_step, :course_ware => @course_ware_1)
    
    @cstep_2_1 = FactoryGirl.create(:css_step, :course_ware => @course_ware_2)
    @cstep_2_2 = FactoryGirl.create(:css_step, :course_ware => @course_ware_2)
    @cstep_2_3 = FactoryGirl.create(:css_step, :course_ware => @course_ware_2)
    @cstep_2_4 = FactoryGirl.create(:css_step, :course_ware => @course_ware_2)
  }

  it{
    @jstep_1_1.is_passed_by?(@user_1).should == false
  }

  it{
    @course_ware_1.passed_step_count_of(@user_1).should == 0
  }

  it{
    @course_ware_1.is_passed_by?(@user_1).should == false
  }

  it{
    @jstep_1_1.passed_users.should == []
  }

  it{
    @jstep_1_1.unpassed_users.should == []
  }

  it{
    @jstep_1_1.tried_users.should == []
  }

  it{
    @course_ware_1.read_count_of(@user_1).should == 0
  }

  describe 'user_1 一次完成 jstep_1_1' do
    before{
      @sh = @jstep_1_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_1.reload
      @course_ware_1.reload
    }

    it{
      @sh.course_ware.should == @course_ware_1
    }

    it{
      @jstep_1_1.passed_users.should =~ [@user_1]
    }

    it{
      @jstep_1_1.unpassed_users.should =~ []
    }

    it{
      @jstep_1_1.tried_users.should =~ [@user_1]
    }

    it{
      @jstep_1_1.is_passed_by?(@user_1).should == true
    }

    it{
      @course_ware_1.passed_step_count_of(@user_1).should == 1
    }

    it{
      @course_ware_1.is_passed_by?(@user_1).should == false
    }

    it{
      @course_ware_1.read_count_of(@user_1).should == 1
    }
  end

  describe 'user_1 多次完成 cstep_2_1' do
    before{
      @cstep_2_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => false)
      @cstep_2_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @cstep_2_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => false)
      @cstep_2_1.reload
      @course_ware_2.reload
    }

    it{
      @cstep_2_1.passed_users.should =~ [@user_1]
    }

    it{
      @cstep_2_1.unpassed_users.should =~ []
    }

    it{
      @cstep_2_1.tried_users.should =~ [@user_1]
    }

    it{
      @cstep_2_1.is_passed_by?(@user_1).should == true
    }

    it{
      @course_ware_2.passed_step_count_of(@user_1).should == 1
    }

    it{
      @course_ware_2.is_passed_by?(@user_1).should == false
    }

    it{
      @course_ware_2.read_count_of(@user_1).should == 1
    }
  end

  describe 'user_1 多次完成 course_ware_1' do
    before{
      @jstep_1_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => false)
      @jstep_1_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)

      @jstep_1_2.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_3.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_4.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)      
      
      @course_ware_1.reload
    }

    it{
      @course_ware_1.passed_step_count_of(@user_1).should == 4
    }

    it{
      @course_ware_1.is_passed_by?(@user_1).should == true
    }

    it{
      @course_ware_1.read_count_of(@user_1).should == 4
    }
  end

  describe '多个用户尝试 jstep_1_1' do
    before{
      @jstep_1_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => false)
      @jstep_1_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_1.step_histories.create(:user => @user_2, :input => "xx", :is_passed => false)
      @jstep_1_1.step_histories.create(:user => @user_3, :input => "xx", :is_passed => true)
    
      @jstep_1_1.reload
    }

    it{
      @jstep_1_1.step_histories.count.should == 4
    }

    it{
      @jstep_1_1.passed_users.should =~ [@user_1, @user_3]
    }

    it{
      @jstep_1_1.unpassed_users.should =~ [@user_2]
    }

    it{
      @jstep_1_1.tried_users.should =~ [@user_1, @user_2, @user_3]
    }
  end

  describe '综合测试' do
    before{
      # user_1 完成 course_ware_1
      @jstep_1_1.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_2.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_3.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_4.step_histories.create(:user => @user_1, :input => "xx", :is_passed => true)
      @jstep_1_3.step_histories.create(:user => @user_1, :input => "xx", :is_passed => false)

      # user_2 完成 course_ware_2
      @cstep_2_1.step_histories.create(:user => @user_2, :input => "xx", :is_passed => true)
      @cstep_2_2.step_histories.create(:user => @user_2, :input => "xx", :is_passed => true)
      @cstep_2_3.step_histories.create(:user => @user_2, :input => "xx", :is_passed => true)
      @cstep_2_4.step_histories.create(:user => @user_2, :input => "xx", :is_passed => true)
      @cstep_2_2.step_histories.create(:user => @user_2, :input => "xx", :is_passed => false)

      # user_3 course_ware_1 course_ware_2 都完成一半
      @cstep_2_1.step_histories.create(:user => @user_3, :input => "xx", :is_passed => true)
      @cstep_2_2.step_histories.create(:user => @user_3, :input => "xx", :is_passed => true)
      @jstep_1_1.step_histories.create(:user => @user_3, :input => "xx", :is_passed => true)
      @jstep_1_2.step_histories.create(:user => @user_3, :input => "xx", :is_passed => true)

      @course_ware_1.reload
      @course_ware_2.reload
    }

    it{
      @course_ware_1.passed_step_count_of(@user_1).should == 4
      @course_ware_1.passed_step_count_of(@user_2).should == 0
      @course_ware_1.passed_step_count_of(@user_3).should == 2

      @course_ware_2.passed_step_count_of(@user_1).should == 0
      @course_ware_2.passed_step_count_of(@user_2).should == 4
      @course_ware_2.passed_step_count_of(@user_3).should == 2
    }

    it{
      @course_ware_1.is_passed_by?(@user_1).should == true
      @course_ware_1.is_passed_by?(@user_2).should == false
      @course_ware_1.is_passed_by?(@user_3).should == false

      @course_ware_2.is_passed_by?(@user_1).should == false
      @course_ware_2.is_passed_by?(@user_2).should == true
      @course_ware_2.is_passed_by?(@user_3).should == false
    }

    it{
      @course_ware_1.read_count_of(@user_1).should == 4
      @course_ware_1.read_count_of(@user_2).should == 0
      @course_ware_1.read_count_of(@user_3).should == 2

      @course_ware_2.read_count_of(@user_1).should == 0
      @course_ware_2.read_count_of(@user_2).should == 4
      @course_ware_2.read_count_of(@user_3).should == 2
    }
  end

end