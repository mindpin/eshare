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

  describe "image" do
    before{
      @image = File.new(Rails.root.join("spec/data/file_entity.jpg"))
      user.notes.create(:content => 'content1', :is_private => true,:course_ware => course_ware)
    }
    
    it{
      user.notes.first.image.identifier.should == nil
    }

    it{
      @note = user.notes.first
      @note.image = @image
      @note.save!
      puts @note.image.identifier
      @note.image.identifier.should_not == nil
    }
  end

  it{
    user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
    user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
    user.notes.size.should == 2
  }

  describe "Note.by_course by_chapter by_course_ware privacy publicity" do
    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter1)
      Note.by_course(chapter.course).size.should == 1
    }

    it{
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      user1.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      Note.by_chapter(chapter).size.should == 2
    }

    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user1.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      Note.by_course_ware(course_ware).size.should== 2
    }

    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.create(:content => 'context1',:is_private => false,:chapter => chapter)
      Note.by_privacy.size.should == 1
    }

    it{
      user.notes.create(:content => 'content1',:is_private => true,:course_ware => course_ware)
      user.notes.create(:content => 'context1',:is_private => true,:chapter => chapter)
      Note.by_privacy.size.should == 2
    }
  end


end