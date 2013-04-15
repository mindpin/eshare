require 'spec_helper'

describe CoursesController do
  before {
    @user = FactoryGirl.create :user
    sign_in @user
    @course = FactoryGirl.create :course
  }

  context '#sign' do
    before {
      xhr :post, :sign, :id => @course.id
    }

    it { response.code.should == '200'}
  end
end