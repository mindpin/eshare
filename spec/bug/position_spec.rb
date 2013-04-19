require 'spec_helper'
describe 'position' do
  describe 'course' do
    before{
      @course_1 = FactoryGirl.create(:course)
      @course_2 = FactoryGirl.create(:course)

      @chapter_1_1 = FactoryGirl.create(:chapter, :course => @course_1)
      @chapter_2_1 = FactoryGirl.create(:chapter, :course => @course_2)

      @chapter_1_2 = FactoryGirl.create(:chapter, :course => @course_1)
      @chapter_2_2 = FactoryGirl.create(:chapter, :course => @course_2)

      @chapter_1_3 = FactoryGirl.create(:chapter, :course => @course_1)
      @chapter_2_3 = FactoryGirl.create(:chapter, :course => @course_2)
    }

    it{
      @course_1.chapters.should == [
        @chapter_1_1,
        @chapter_1_2,
        @chapter_1_3
      ]
    }

    it{
      @chapter_1_2.prev.should == @chapter_1_1
    }

    it{
      @chapter_1_2.next.should == @chapter_1_3
    }

    it{
      @chapter_1_2.move_up
      @course_1.chapters.reload
      @course_1.chapters.should == [
        @chapter_1_2,
        @chapter_1_1,
        @chapter_1_3
      ]
    }

    it{
      @chapter_1_2.move_down
      @course_1.chapters.reload
      @course_1.chapters.should == [
        @chapter_1_1,
        @chapter_1_3,
        @chapter_1_2
      ]
    }

    it{
      @chapter_1_2.move_up.move_up
      @course_1.chapters.reload
      @course_1.chapters.should == [
        @chapter_1_2,
        @chapter_1_1,
        @chapter_1_3
      ]
    }

    it{
      @chapter_1_2.move_down.move_down
      @course_1.chapters.reload
      @course_1.chapters.should == [
        @chapter_1_1,
        @chapter_1_3,
        @chapter_1_2
      ]
    }
  end

  describe 'course_ware' do
    before{
      @chapter_1 = FactoryGirl.create(:chapter)
      @chapter_2 = FactoryGirl.create(:chapter)

      @course_ware_1_1 = FactoryGirl.create(:course_ware, :chapter => @chapter_1)
      @course_ware_2_1 = FactoryGirl.create(:course_ware, :chapter => @chapter_2)

      @course_ware_1_2 = FactoryGirl.create(:course_ware, :chapter => @chapter_1)
      @course_ware_2_2 = FactoryGirl.create(:course_ware, :chapter => @chapter_2)

      @course_ware_1_3 = FactoryGirl.create(:course_ware, :chapter => @chapter_1)
      @course_ware_2_3 = FactoryGirl.create(:course_ware, :chapter => @chapter_2)
    }

    it{
      @chapter_1.course_wares.should == [
        @course_ware_1_1,
        @course_ware_1_2,
        @course_ware_1_3
      ]
    }

    it{
      @course_ware_1_2.prev.should == @course_ware_1_1
    }

    it{
      @course_ware_1_2.next.should == @course_ware_1_3
    }

    it{
      @course_ware_1_2.move_up
      @chapter_1.course_wares.reload
      @chapter_1.course_wares.should == [
        @course_ware_1_2,
        @course_ware_1_1,
        @course_ware_1_3
      ]
    }

    it{
      @course_ware_1_2.move_up.move_up
      @chapter_1.course_wares.reload
      @chapter_1.course_wares.should == [
        @course_ware_1_2,
        @course_ware_1_1,
        @course_ware_1_3
      ]
    }

    it{
      @course_ware_1_2.move_down
      @chapter_1.course_wares.reload
      @chapter_1.course_wares.should == [
        @course_ware_1_1,
        @course_ware_1_3,
        @course_ware_1_2
      ]
    }

    it{
      @course_ware_1_2.move_down.move_down
      @chapter_1.course_wares.reload
      @chapter_1.course_wares.should == [
        @course_ware_1_1,
        @course_ware_1_3,
        @course_ware_1_2
      ]
    }
  end


end

