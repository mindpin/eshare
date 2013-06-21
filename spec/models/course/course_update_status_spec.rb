require "spec_helper"

describe Course do
  describe 'course_wares_count' do
    before{
      @course = FactoryGirl.create(:course)
      @chapter = @course.chapters.create!(:title => "1", :creator => @course.creator)
    }

    it{
      @course.course_wares.count.should == 0
      @course.course_wares_count.should == 0
      @course.updated_at.to_i.should == @course.created_at.to_i
    }

    it{
      Timecop.travel(Time.now + 6.day) do
        @course_ware = @chapter.course_wares.create!(:title => "cw1",:desc => "cw1", :creator => @course.creator)
      end
      @course.reload
      @course.course_wares.count.should == 1
      @course.course_wares_count.should == 1
      @course.updated_at.to_i.should_not == @course.created_at.to_i
      @course.updated_at.to_i.should == @course_ware.created_at.to_i
    }
  end


end