require "spec_helper"

describe Chapter do
  describe '上下移动' do
    before {
      3.times { FactoryGirl.create(:chapter) }
      @chapters = Chapter.all

      @first_chapter = @chapters.first
      @second_chapter = @chapters.second
      @last_chapter = @chapters.last
    }

    it "主键 id 跟 position 相等" do
      @first_chapter.id.should == @first_chapter.position
      @second_chapter.id.should == @second_chapter.position
      @last_chapter.id.should == @last_chapter.position
    end

    it "最后一个向上移动" do
      @last_chapter.move_up

      @second_chapter.position.should == @last_chapter.id
    end

    it "向下移动" do
      @first_chapter.move_down

      @first_chapter.position.should == @first_chapter.id
    end

  end
end