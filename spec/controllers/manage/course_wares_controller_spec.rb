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
end