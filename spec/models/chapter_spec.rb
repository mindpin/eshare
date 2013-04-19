require "spec_helper"

describe Chapter do
  describe '上下移动' do
    before {
      @course = FactoryGirl.create(:course)

      3.times { FactoryGirl.create(:chapter, :course => @course) }
      chapters = Chapter.all

      @chapter1 = chapters.first
      @chapter2 = chapters.second
      @chapter3 = chapters.last
    }

    it "最后上一个" do
      @chapter3.prev.should == @chapter2
    end

    it "中间上一个" do
      @chapter2.prev.should == @chapter1
    end

    it "第一个下一个" do
      @chapter1.next.should == @chapter2
    end

    it "中间下一个" do
      @chapter2.next.should == @chapter3
    end

    it "主键 id 跟 position 相等" do
      @chapter1.id.should == @chapter1.position
      @chapter2.id.should == @chapter2.position
      @chapter3.id.should == @chapter3.position
    end

    it "最后一个向上移动" do
      @chapter3.move_up

      Chapter.all.should == [
        @chapter1,
        @chapter3,
        @chapter2
      ]
    end

    it "最后一个上下移动" do
      @chapter3.move_up.move_down
      Chapter.all.should == [
        @chapter1,  
        @chapter2,
        @chapter3
      ]
    end

    it "最后一个向上移动两次" do
      @chapter3.move_up.move_up
      Chapter.all.should == [
        @chapter3,
        @chapter1,
        @chapter2
      ]
    end

    it "第一个上下移动" do
      @chapter1.move_down.move_up
      Chapter.all.should == [
        @chapter1,
        @chapter2,
        @chapter3
      ]
    end

    it "第一个向下移动" do
      @chapter1.move_down
      Chapter.all.should == [
        @chapter2,
        @chapter1,
        @chapter3
      ]
    end

    it "第一个向下移动两次" do
      @chapter1.move_down.move_down
      Chapter.all.should == [
        @chapter2,
        @chapter3,
        @chapter1
      ]
    end

  end
end