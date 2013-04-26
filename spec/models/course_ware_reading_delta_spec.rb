require 'spec_helper'

describe CourseWareReadingDelta do
  before {
    @user = FactoryGirl.create :user
    @course_ware = FactoryGirl.create :course_ware
  }

  it { @course_ware.read_count_of(@user).should == 0 }

  it { @course_ware.read_count_value_of(@user, Date.today - 4).should == 0 }
  it { @course_ware.read_count_value_of(@user, Date.today - 3).should == 0 }
  it { @course_ware.read_count_value_of(@user, Date.today - 2).should == 0 }
  it { @course_ware.read_count_value_of(@user, Date.today - 1).should == 0 }
  it { @course_ware.read_count_value_of(@user, Date.today - 0).should == 0 }

  it { @course_ware.read_count_delta_of(@user, Date.today - 3).should == 0 }
  it { @course_ware.read_count_delta_of(@user, Date.today - 2).should == 0 }
  it { @course_ware.read_count_delta_of(@user, Date.today - 1).should == 0 }
  it { @course_ware.read_count_delta_of(@user, Date.today - 0).should == 0 }

  context {
    before {
      Timecop.travel(Time.now - 3.day) do
        @course_ware.update_read_count_by(@user, 10)
      end
    }

    it { @course_ware.read_count_of(@user).should == 10 }
    it { CourseWareReadingDelta.count.should == 1}

    it { @course_ware.read_count_value_of(@user, Date.today - 4).should == 0 }
    it { @course_ware.read_count_value_of(@user, Date.today - 3).should == 10 }
    it { @course_ware.read_count_value_of(@user, Date.today - 2).should == 10 }
    it { @course_ware.read_count_value_of(@user, Date.today - 1).should == 10 }
    it { @course_ware.read_count_value_of(@user, Date.today - 0).should == 10 }

    it { @course_ware.read_count_delta_of(@user, Date.today - 3).should == 10 }
    it { @course_ware.read_count_delta_of(@user, Date.today - 2).should == 0 }
    it { @course_ware.read_count_delta_of(@user, Date.today - 1).should == 0 }
    it { @course_ware.read_count_delta_of(@user, Date.today - 0).should == 0 }
  }

  context do
    before {
      Timecop.travel(Time.now - 3.day) do
        @course_ware.update_read_count_by(@user, 10)
      end

      Timecop.travel(Time.now - 1.day) do
        @course_ware.update_read_count_by(@user, 10)
        @course_ware.update_read_count_by(@user, 50)
      end
    }

    it { @course_ware.read_count_of(@user).should == 50 }
    it { CourseWareReadingDelta.count.should == 2}

    it { @course_ware.read_count_value_of(@user, Date.today - 4).should == 0 }
    it { @course_ware.read_count_value_of(@user, Date.today - 3).should == 10 }
    it { @course_ware.read_count_value_of(@user, Date.today - 2).should == 10 }
    it { @course_ware.read_count_value_of(@user, Date.today - 1).should == 50 }
    it { @course_ware.read_count_value_of(@user, Date.today - 0).should == 50 }

    it { @course_ware.read_count_delta_of(@user, Date.today - 3).should == 10 }
    it { @course_ware.read_count_delta_of(@user, Date.today - 2).should == 0 }
    it { @course_ware.read_count_delta_of(@user, Date.today - 1).should == 40 }
    it { @course_ware.read_count_delta_of(@user, Date.today - 0).should == 0 }
  end

  # context '不同日期的增量' do
  #   before {
  #     Timecop.travel(Time.now - 3.day) do
  #       @course_ware.update_read_count_by(@user, 10)
  #       @course_ware.update_read_count_by(@user, 20)
  #       @course_ware.update_read_count_by(@user, 50)
  #     end

  #     Timecop.travel(Time.now - 1.day) do
  #       @course_ware.update_read_count_by(@user, 30)
  #       @course_ware.update_read_count_by(@user, 80)
  #       @course_ware.update_read_count_by(@user, 100)
  #     end
  #   }

  #   it {
  #     CourseWareReadingDelta.count.should == 3
  #   }

  #   it {
  #     @course_ware.read_count_delta_of(@user, Date.today - 3).should == 50 - 10
  #   }

  #   it {
  #     @course_ware.read_count_delta_of(@user, Date.today - 2).should == 0
  #   }

  #   it {
  #     @course_ware.read_count_delta_of(@user, Date.today - 1).should == 100 - 50
  #   }
  # end
end