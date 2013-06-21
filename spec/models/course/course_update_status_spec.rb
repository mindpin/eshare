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

  describe 'update_status' do
    before{
      Timecop.travel(Time.now - 8.day) do
        @course_1 = FactoryGirl.create(:course)
        @chapter_1 = @course_1.chapters.create!(:title => "1", :creator => @course_1.creator)
        @chapter_1.course_wares.create!(:title => "cw1",:desc => "cw1", :creator => @course_1.creator)
      end

      @course_2 = FactoryGirl.create(:course)
      @chapter_2 = @course_2.chapters.create!(:title => "1", :creator => @course_2.creator)
      @chapter_2.course_wares.create!(:title => "cw1",:desc => "cw1", :creator => @course_2.creator)

      Timecop.travel(Time.now - 8.day) do
        @course_3 = FactoryGirl.create(:course)
        @chapter_3 = @course_3.chapters.create!(:title => "1", :creator => @course_3.creator)
        @chapter_3.course_wares.create!(:title => "cw1",:desc => "cw1", :creator => @course_3.creator)
      end
      @chapter_3.course_wares.create!(:title => "cw2",:desc => "cw2", :creator => @course_3.creator)
    
      @course_4 = FactoryGirl.create(:course)

      @course_1.reload
      @course_2.reload
      @course_3.reload
      @course_4.reload
    }

    it{
      @course_1.get_update_status.should == 'NOCHANGE'
      @course_4.get_update_status.should == 'NOCHANGE'
      @course_2.get_update_status.should == 'NEW'
      @course_3.get_update_status.should == 'UPDATED'
    }

    it{
      Course.with_new_status.should == [@course_2]
    }

    it{
      Course.with_updated_status.should == [@course_3]
    }

    it{
      Course.with_nochange_status.should =~ [@course_1, @course_4]
    }
  end


end
