require "spec_helper"

describe Chapter do
  describe '上下移动' do
    before {
      3.times { FactoryGirl.create(:chapter) }
      @chapters = Chapter.all

      @chapter1 = @chapters.first
      @chapter2 = @chapters.second
      @chapter3 = @chapters.last
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
      @chapters.last.move_up

      @chapter2.position.should == @chapters.last.position
      @chapter3.position.should == @chapters.second.position
    end

    it "最后一个上下移动" do
      @chapters.last.move_up.move_down

      @chapter3.position.should == @chapters.last.position
    end

    it "最后一个向上移动两次" do
      @chapters.last.move_up.move_up

      @chapter1.position.should == @chapters.last.position
    end

    it "第一个上下移动" do
      @chapters.first.move_down.move_up

      @chapter1.position.should == @chapters.first.position
    end

    it "第一个向下移动" do
      @chapters.first.move_down

      @chapter2.position.should == @chapters.first.position
      @chapter1.position.should == @chapters.second.position
    end

    it "第一个向下移动两次" do
      @chapters.first.move_down.move_down

      @chapter3.position.should == @chapters.first.position
    end

  end
end