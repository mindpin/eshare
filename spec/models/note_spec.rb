require 'spec_helper'

describe Note do
  let(:user) {FactoryGirl.create :user}
  let(:user1) {FactoryGirl.create :user}

  let(:course_ware) {FactoryGirl.create :course_ware}
  let(:course_ware1) {FactoryGirl.create :course_ware}

  let(:course) {FactoryGirl.create :course}
  let(:course1) {FactoryGirl.create :course}

  let(:chapter) {FactoryGirl.create :chapter}
  let(:chapter1) {FactoryGirl.create :chapter}


  describe "user.notes.create" do
    it {
      expect {
        user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      }.to change{
        Note.count
      }.by(1)
    }

    it {
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.first.chapter_id.should == course_ware.chapter_id
    }

    it {
      expect {
        user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      }.to change{
        Note.count
      }.by(1)
    }

    it {
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      user.notes.first.course_id.should == chapter.course_id
    }
  end

  it{
    user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
    user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
    user.notes.size == 2
  }

  describe "Note.by_course by_chapter by_course_ware privacy publicity" do
    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      Note.by_course(chapter.course).first == chapter.course
    }

    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      Note.by_chapter(course_ware.chapter).first == course_ware.chapter
    }

    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      Note.by_course_ware(course_ware).first == course_ware
    }

    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      Note.by_privacy.size == 1
    }

    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.create(:content => 'context1',:is_private => true,:chapter => chapter)
      Note.by_privacy.size == 2
    }
  end


end