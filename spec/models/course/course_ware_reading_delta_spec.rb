require 'spec_helper'

describe CourseWareReadingDelta do
  before {
    @user = FactoryGirl.create :user
    @course_ware = FactoryGirl.create :course_ware, :total_count => 1000
  }

  it { @course_ware.read_count_of(@user).should == 0 }

  it { @course_ware.read_count_value_of(@user, Date.today - 4).should == 0 }
  it { @course_ware.read_count_value_of(@user, Date.today - 3).should == 0 }
  it { @course_ware.read_count_value_of(@user, Date.today - 2).should == 0 }
  it { @course_ware.read_count_value_of(@user, Date.today - 1).should == 0 }
  it { @course_ware.read_count_value_of(@user, Date.today - 0).should == 0 }

  it { @course_ware.read_count_change_of(@user, Date.today - 3).should == 0 }
  it { @course_ware.read_count_change_of(@user, Date.today - 2).should == 0 }
  it { @course_ware.read_count_change_of(@user, Date.today - 1).should == 0 }
  it { @course_ware.read_count_change_of(@user, Date.today - 0).should == 0 }

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

    it { @course_ware.read_count_change_of(@user, Date.today - 3).should == 10 }
    it { @course_ware.read_count_change_of(@user, Date.today - 2).should == 0 }
    it { @course_ware.read_count_change_of(@user, Date.today - 1).should == 0 }
    it { @course_ware.read_count_change_of(@user, Date.today - 0).should == 0 }
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

    it { @course_ware.read_count_change_of(@user, Date.today - 3).should == 10 }
    it { @course_ware.read_count_change_of(@user, Date.today - 2).should == 0 }
    it { @course_ware.read_count_change_of(@user, Date.today - 1).should == 40 }
    it { @course_ware.read_count_change_of(@user, Date.today - 0).should == 0 }

    it {
      @course_ware.last_week_read_count_changes_of(@user).should == [
        {:date => Date.today - 6, :change => 0,  :value => 0},
        {:date => Date.today - 5, :change => 0,  :value => 0},
        {:date => Date.today - 4, :change => 0,  :value => 0},
        {:date => Date.today - 3, :change => 10, :value => 10},
        {:date => Date.today - 2, :change => 0,  :value => 10},
        {:date => Date.today - 1, :change => 40, :value => 50},
        {:date => Date.today - 0, :change => 0,  :value => 50}
      ]
    }
  end
end