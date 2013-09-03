require "spec_helper"
require 'sidekiq/testing'

describe CourseWare do
  context 'new' do
    before{
      chapter = FactoryGirl.create(:chapter)
      @course_ware = chapter.course_wares.new
    }

    it{
      @course_ware.markdown.should == ""
    }
  end
  context '创建基本的 markdown 教程' do
    before{
      @markdown_content = %`
        内容内容内容
      `
      chapter = FactoryGirl.create(:chapter)
      creator = FactoryGirl.create(:user)
      @course_ware = CourseWare.new({
        :title   => 'title',
        :desc    => 'desc',
        :chapter_id => chapter.id,
        :markdown => @markdown_content
        },
        :as => :markdown
      )
      @course_ware.creator = creator
      @course_ware.save!
    }

    it{
      @course_ware.reload
      @course_ware.kind.should == 'markdown'
      @course_ware.markdown.should == @markdown_content
    }
  end

  context '创建有外链图片的 markdown 教程' do
    before{
      @outer_url = "http://iamge.baidu.com/static/widget/common/header/img/wantu-logo-big_63c2ebcc29.gif"
      @markdown_content = %`
        内容内容内容
        ![image](#{@outer_url}) 图片
      `
      chapter = FactoryGirl.create(:chapter)
      creator = FactoryGirl.create(:user)
      @course_ware = CourseWare.new({
        :title   => 'title',
        :desc    => 'desc',
        :chapter_id => chapter.id,
        :markdown => @markdown_content
        },
        :as => :markdown
      )
      @course_ware.creator = creator
      @course_ware.save!
      @course_ware.reload
    }

    it{
      @course_ware.kind.should == 'markdown'
      @course_ware.markdown.should == @markdown_content
    }

    it{
      @course_ware.markdown(:replace_outer_url => true).should == %`
        内容内容内容
        ![image](#{FileEntity::DOWNLOADING_URL}) 图片
      `
      entity = FileEntity.get_outer_image(@outer_url)
      FileEntityDownloadOuterUrl.perform_async(entity.id)
      FileEntityDownloadOuterUrl.drain
      entity.reload
      @course_ware.markdown(:replace_outer_url => true).should == %`
        内容内容内容
        ![image](#{entity.attach.url}) 图片
      `
    }

    context '修改' do
      before{
        @outer_url = "http://iamge.baidu.com/static/widget/common/header/img/wantu-logo-big_63c2ebcc29.gif"
        @outer_url2 = "http://www.baidu.com/img/bdlogo.gif"
        @markdown_content = %`
          内容内容内容
          ![image](#{@outer_url}) 图片
          ![image](#{@outer_url2})
        `
        @course_ware.markdown = @markdown_content
        @course_ware.save
        @course_ware.reload
      }

      it{
        @course_ware.markdown.should == @markdown_content
        @course_ware.markdown(:replace_outer_url => true).should == %`
          内容内容内容
          ![image](#{FileEntity.get_outer_image(@outer_url).url}) 图片
          ![image](#{FileEntity.get_outer_image(@outer_url2).url})
        `
      }
    end
  end
end