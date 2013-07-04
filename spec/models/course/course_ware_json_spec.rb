require 'spec_helper'

describe CourseWare do
  before {
    
    @course_ware = FactoryGirl.create(:course_ware,
      :title => 'js title',
      :desc => 'js desc',
      :kind => 'javascript',
    )

    @step1 = FactoryGirl.create(:javascript_step,
      :course_ware => @course_ware,
      :content => 'content 1',
      :rule => 'rule 1',
      :title => 'title 1',
      :desc => 'desc 1',
      :hint => 'hint 1',
      :init_code => 'init_code 1'
    )

    @step2 = FactoryGirl.create(:javascript_step,
      :course_ware => @course_ware,
      :content => 'content 2',
      :rule => 'rule 2',
      :title => 'title 2',
      :desc => 'desc 2',
      :hint => 'hint 2',
      :init_code => 'init_code 2'
    )
  }

  it "验证导出" do
    @course_ware.export_json.should == {
      :title => 'js title',
      :desc => 'js desc',
      :kind => 'javascript',
      :total_count => 2,
      :steps => [
        {
          :content => 'content 1',
          :rule => 'rule 1',
          :title => 'title 1',
          :desc => 'desc 1',
          :hint => 'hint 1',
          :init_code => 'init_code 1'
        },
        {
          :content => 'content 2',
          :rule => 'rule 2',
          :title => 'title 2',
          :desc => 'desc 2',
          :hint => 'hint 2',
          :init_code => 'init_code 2'
        }
      ]
    }.to_json
  end

  describe "验证导入" do
    before {
      
      @json_data = @course_ware.export_json

      @user = FactoryGirl.create(:user)
      @chapter = FactoryGirl.create(:chapter)

      @course_ware = @chapter.import_javascript_course_ware_from_json(@json_data, @user)
    }

    describe "导入正确" do
      it "chapter" do
        @course_ware.chapter.should == @chapter
      end

      it "user" do
        @course_ware.creator.should == @user
      end

      it "title" do
        @course_ware.title.should == 'js title'
      end

      it "desc" do
        @course_ware.desc.should == 'js desc'
      end

      it "kind" do
        @course_ware.kind.should == 'javascript'
      end

      it "total_count" do
        @course_ware.total_count.should == 2
      end

      it "steps 数量" do
        @course_ware.javascript_steps.count.should == 2
      end



      describe "验证 steps" do
        before {
          @step1 = @course_ware.javascript_steps[0]
          @step2 = @course_ware.javascript_steps[1]
        }


        describe "step 1" do
          it "content" do
            @step1.content.should == 'content 1'
          end

          it "rule" do
            @step1.rule.should == 'rule 1'
          end

          it "title" do
            @step1.title.should == 'title 1'
          end

          it "desc" do
            @step1.desc.should == 'desc 1'
          end

          it "hint" do
            @step1.hint.should == 'hint 1'
          end

          it "init_code" do
            @step1.init_code.should == 'init_code 1'
          end
        end

        describe "step 2" do
          it "content" do
            @step2.content.should == 'content 2'
          end

          it "rule" do
            @step2.rule.should == 'rule 2'
          end

          it "title" do
            @step2.title.should == 'title 2'
          end

          it "desc" do
            @step2.desc.should == 'desc 2'
          end

          it "hint" do
            @step2.hint.should == 'hint 2'
          end

          it "init_code" do
            @step2.init_code.should == 'init_code 2'
          end
        end

      end

    end
  end

end