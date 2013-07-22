require "spec_helper"

describe Question do

  describe 'create question for javascript_step' do
    before {
      @user         = FactoryGirl.create :user
      @course = FactoryGirl.create(:course)
      @chapter = FactoryGirl.create(:chapter, :course => @course)
      @course_ware = FactoryGirl.create(:course_ware, :kind => 'javascript', :chapter => @chapter)
      
      @step = @course_ware.javascript_steps.create(:content => "content", :rule => "rule")
      @step_history_1 = @step.step_histories.create(:user => @user, :input => "xx", :is_passed => true)
      @step_history_2 = @step.step_histories.create(:user => @user, :input => "xx", :is_passed => true)

      @question_attr_hash = {:title => 'title', :content => 'content'}
    }

    describe "include_code: true" do
      before {
        @include_code = true
        @question = @step.create_question(@user, @question_attr_hash, @include_code)
      }

      it "valid question" do
        @question.valid?.should == true
      end

      it "user" do
        @question.creator.should == @user
      end

      it "title" do
        @question.title.should == @question_attr_hash[:title]
      end

      it "content" do
        @question.content.should == @question_attr_hash[:content]
      end

      it "step_history" do
        @question.step_history.should == @step_history_2
      end

      describe "course, course_ware, chapter" do

        it "course" do
          @question.course.should == @course
        end

        it "chapter" do
          @question.chapter.should == @chapter
        end

        it "course_ware" do
          @question.course_ware.should == @course_ware
        end
        
      end

    end

    describe "include_code: false" do
      before {
        @include_code = false
        @question = @step.create_question(@user, @question_attr_hash, @include_code)
      }

      it "valid question" do
        @question.valid?.should == true
      end

      it "user" do
        @question.creator.should == @user
      end

      it "title" do
        @question.title.should == @question_attr_hash[:title]
      end

      it "content" do
        @question.content.should == @question_attr_hash[:content]
      end

      it "step_history" do
        @question.step_history.should == nil
      end

    end



  end

end