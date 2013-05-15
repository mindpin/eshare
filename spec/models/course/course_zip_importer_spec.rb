# -*- coding: utf-8 -*-
require 'spec_helper'

describe CourseZipImporter do
  before {
    creator = FactoryGirl.create :user
    zip_path = 'spec/support/resources/course.zip'
    Course.import_zip_file zip_path, creator

    @course = Course.find_by_name('zip导入课程')
  }

  describe "检查 course" do
    it "name 正确" do
      @course.name.should == 'zip导入课程'
    end

    it "desc 正确" do
      @course.desc.should == '课程描述'
    end

    describe "检查 chapters" do
      before {
        @chapters = @course.chapters
      }

      describe "第一个 chapter" do
        before {
          @chapter_1 = @chapters.first
        }

        it "title 正确" do
          @chapter_1.title.should == '章节1'
        end

        it "desc 正确" do
          @chapter_1.desc.should == '章节1描述'
        end

        describe "检查 wares" do
          before {
            @wares = @chapter_1.course_wares
          }

          describe "第一个 ware" do
            before {
              @ware_1 = @wares.first
            }

            it "title 正确" do
              @ware_1.title.should == '视频1'
            end

            it "kind 正确" do
              @ware_1.kind.should == 'flv'
            end
          end

          describe "第二个 ware" do
            before {
              @ware_2 = @wares.last
            }

            it "title 正确" do
              @ware_2.title.should == '视频2'
            end

            it "kind 正确" do
              @ware_2.kind.should == 'youku'
            end

            it "url 正确" do
              @ware_2.url.should == 'http://v.youku.com/v_show/id_ZXNTDz4DQxCDY4.html'
            end
          end
        end

        describe "检查 practices" do
          before {
            @practices = @chapter_1.practices
            @practice_1 = @practices.first
          }

          it "title 正确" do
            @practice_1.title.should == '章节1作业1'
          end
        end
      end

      describe "第二个 chapter" do
        before {
          @chapter_2 = @chapters.last
        }

        it "title 正确" do
          @chapter_2.title.should == '章节2'
        end

        it "desc 正确" do
          @chapter_2.desc.should == '章节2描述'
        end
      end

    end
  end

 
end
