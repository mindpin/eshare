require 'spec_helper'

describe Manage::CourseWaresController do
  before {
    @user = FactoryGirl.create :user
    sign_in @user

    @chapter = FactoryGirl.create :chapter
  }

  context '#new web_video' do
    before {
      get :new, :chapter_id => @chapter.id, :for => 'web_video'
    }

    it { response.code.should == '200' }
  end

  context '#move_up, #move_down' do
    before {
      8.times do
        FactoryGirl.create :course_ware, :chapter => @chapter
      end

      @pos = @chapter.course_wares.map(&:position)
    }

    it {
      put :move_up, :id => @chapter.course_wares.last.id
      @chapter.course_wares.unscoped.map(&:position).should_not == @pos
    }

    it {
      put :move_down, :id => @chapter.course_wares.last.id
      @chapter.course_wares.unscoped.map(&:position).should == @pos
    }

    it {
      put :move_up, :id => @chapter.course_wares.first.id
      @chapter.course_wares.unscoped.map(&:position).should == @pos
    }

    it {
      put :move_down, :id => @chapter.course_wares.first.id
      @chapter.course_wares.unscoped.map(&:position).should_not == @pos
    }
  end
end