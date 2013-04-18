require 'spec_helper'

describe Manage::ChaptersController do
  context '#move_up, #move_down' do
    before {
      @user = FactoryGirl.create :user
      sign_in @user

      @course = FactoryGirl.create :course

      8.times do
        FactoryGirl.create :chapter, :course => @course
      end

      @pos = @course.chapters.map(&:position)
    }

    it {
      put :move_up, :id => @course.chapters.last.id
      @course.chapters.unscoped.map(&:position).should_not == @pos
    }

    it {
      put :move_down, :id => @course.chapters.last.id
      @course.chapters.unscoped.map(&:position).should == @pos
    }

    it {
      put :move_up, :id => @course.chapters.first.id
      @course.chapters.unscoped.map(&:position).should == @pos
    }

    it {
      put :move_down, :id => @course.chapters.first.id
      @course.chapters.unscoped.map(&:position).should_not == @pos
    }
  end
end