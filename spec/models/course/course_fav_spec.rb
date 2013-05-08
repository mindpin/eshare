require 'spec_helper'

describe CourseFav do
  let(:user)    { FactoryGirl.create(:user) }
  let(:course)  {FactoryGirl.create(:course)}
  let(:options) { {
                    :comment_content => '有评论',
                    :tags => '有Tag'
                } }

  let(:options_no_tags) { {
                    :comment_content => '有评论'
                } }

  let(:options_no_comment_content) { {
                  :tags => '有Tag'
              } }

  let(:options_is_nil) {{}}

  let(:options_has_manys_tag) { {
                    :comment_content => '有评论',
                    :tags => '有多个Tag Tag1 Tag2'
                } }

  context '#set_fav(user, options)' do
    it{
      expect {
        course.set_fav(user,options)
      }.to change {
        course.course_favs.count
      }.by(1)
    }

    it{
      expect {
        course.set_fav(user,options_no_tags)
      }.to change {
        course.course_favs.count
      }.by(1)
    }

    it{
      expect {
        course.set_fav(user,options_no_comment_content)
      }.to change {
        course.course_favs.count
      }.by(1)
    }

    it{
      expect {
        course.set_fav(user,options_is_nil)
      }.to change {
        course.course_favs.count
      }.by(1)
    }

    it{
      expect {
        course.set_fav(user,options_has_manys_tag)
      }.to change {
        course.course_favs.count
      }.by(1)
    }
  end
end