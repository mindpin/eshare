require 'spec_helper'

describe CourseDepend do
	before {
    @user   = FactoryGirl.create(:user)

    @course_1 = FactoryGirl.create(:course)
    @course_2 = FactoryGirl.create(:course)
    @course_3 = FactoryGirl.create(:course)
    @course_4 = FactoryGirl.create(:course)

    @course_0 = FactoryGirl.create(:course)
    @course_5 = FactoryGirl.create(:course)


    FactoryGirl.create(:course_depend, :before_course => @course_1, :after_course => @course_4)
    FactoryGirl.create(:course_depend, :before_course => @course_2, :after_course => @course_4)
    FactoryGirl.create(:course_depend, :before_course => @course_3, :after_course => @course_4)

    FactoryGirl.create(:course_depend, :before_course => @course_2, :after_course => @course_3)
    FactoryGirl.create(:course_depend, :before_course => @course_1, :after_course => @course_3)
  }

  describe "before_courses" do
  	it "course_1" do
  		@course_1.before_courses.should =~ []
  	end

  	it "course_2" do
  		@course_2.before_courses.should =~ []
  	end

  	it "course_3" do
  		@course_3.before_courses.should =~ [@course_2, @course_1]
  	end

  	it "course_4" do
  		@course_4.before_courses.should =~ [@course_1, @course_2, @course_3]
  	end

  	describe "add_before_course" do
  		before {
  			@course_1.add_before_course(@course_0)
  			@course_2.add_before_course(@course_0)
  			@course_3.add_before_course(@course_0)
  			@course_4.add_before_course(@course_0)
  		}

  		it "course_1" do
	  		@course_1.before_courses.should =~ [@course_0]
	  	end

	  	it "course_2" do
	  		@course_2.before_courses.should =~ [@course_0]
	  	end

	  	it "course_3" do
	  		@course_3.before_courses.should =~ [@course_0, @course_1, @course_2]
	  	end

	  	it "course_4" do
	  		@course_4.before_courses.should =~ [@course_0, @course_1, @course_2, @course_3]
	  	end
  	end

  end

  describe "after_courses" do
  	it "course_1" do
  		@course_1.after_courses.should =~ [@course_3, @course_4]
  	end

  	it "course_2" do
  		@course_2.after_courses.should =~ [@course_3, @course_4]
  	end

  	it "course_3" do
  		@course_3.after_courses.should =~ [@course_4]
  	end

  	it "course_4" do
  		@course_4.after_courses.should =~ []
  	end

  	describe "add_after_course" do
  		before {
  			@course_1.add_after_course(@course_5)
  			@course_2.add_after_course(@course_5)
  			@course_3.add_after_course(@course_5)
  			@course_4.add_after_course(@course_5)
  		}

  		it "course_1" do
	  		@course_1.after_courses.should =~ [@course_3, @course_4, @course_5]
	  	end

	  	it "course_2" do
	  		@course_2.after_courses.should =~ [@course_3, @course_4, @course_5]
	  	end

	  	it "course_3" do
	  		@course_3.after_courses.should =~ [@course_4, @course_5]
	  	end

	  	it "course_4" do
	  		@course_4.after_courses.should =~ [@course_5]
	  	end
  	end

  end


end