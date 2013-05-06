require "spec_helper"

describe ShortMessage do

  describe "发送信息" do

    before {
      @sender = FactoryGirl.create :user
      @receiver = FactoryGirl.create :user
      @content = "content"

      @sender.send_message(@content, @receiver)
      @message = ShortMessage.last    }

    it "发送者正确" do
      @message.sender.should == @sender
    end

    it "接收者正确" do
      @message.receiver.should == @receiver
    end

    it "发送内容正确" do
      @message.content.should == @content
    end

    it "未读状态" do
      @message.receiver_read.should == false
    end

    it "转成已读状态" do
      @message.receiver_read!

      @message.receiver_read.should == true
    end

    it "发送者还未曾删除" do
      @message.sender_hide.should == false
    end

    it "发送者删除信息" do
      @sender.remove_short_message(@message)

      @message.sender_hide.should == true
    end

    it "接收者还未曾删除" do
      @message.receiver_hide.should == false
    end

    it "接收者删除信息" do
      @receiver.remove_short_message(@message)

      @message.receiver_hide.should == true
    end

  end


  describe "收件箱列表" do

    before {
      @sender_1 = FactoryGirl.create :user
      @sender_2 = FactoryGirl.create :user
      @sender_3 = FactoryGirl.create :user

      @receiver = FactoryGirl.create :user
      @content = "content"

    }

    describe "一个发送者 对 一个接收者 单方向 发送信息" do

      before {
        2.times { @sender_1.send_message(@content, @receiver) }
        @message = @sender_1.send_message(@content, @receiver)

        @inbox_list = @receiver.inbox

      }

      it "收件箱数量正确" do
        @inbox_list.count.should == 1
      end

      it "收件箱列表顺序正确" do
        @inbox_list.should == [@meessage]
      end

    end


    describe "一个发送者 和 一个接收者 互相 发送信息" do
      before {
        @message_1 = @sender_1.send_message(@content, @receiver)
        @message_2 = @receiver.send_message(@content, @sender_1)
        @message_3 = @sender_1.send_message(@content, @receiver)
        @message_4 = @receiver.send_message(@content, @sender_1)

        @sender_inbox_list = @sender_1.inbox
        @receiver_inbox_list = @receiver.inbox
      }

      it "sender 收件箱数量正确" do
        @sender_inbox_list.count.should == 1
      end

      it "sender 收件箱列表顺序正确" do
        @sender_inbox_list.should == [@message_3]
      end

      it "receiver 收件箱数量正确" do
        @receiver_inbox_list.count.should == 1
      end

      it "sender 收件箱列表顺序正确" do
        @receiver_inbox_list.should == [@message_4]
      end

    end


    describe "二个发送者 对 一个接收者 单方向发送信息" do

      before {
        3.times { @message_1 = @sender_1.send_message(@content, @receiver) }
        3.times { @message_2 = @sender_2.send_message(@content, @receiver) }

        @inbox_list = @receiver.inbox
      }

      it "收件箱数量正确" do
        @inbox_list.count.should == 2
      end

      it "收件箱列表顺序正确" do
        @inbox_list.should == [@message_1, @message_2]
      end

    end


    describe "二个发送者 和 一个接收者 互相 发送信息" do

      before {
        @sender_message_1_1 = @receiver.send_message(@content, @sender_1)
        @sender_message_1_2 = @receiver.send_message(@content, @sender_1)
        @receiver_message_1_1 = @sender_1.send_message(@content, @receiver)
        @receiver_message_1_2 = @sender_1.send_message(@content, @receiver)

        @sender_message_2_1 = @receiver.send_message(@content, @sender_2)
        @sender_message_2_2 = @receiver.send_message(@content, @sender_2)
        @receiver_message_2_1 = @sender_2.send_message(@content, @receiver)
        @receiver_message_2_2 = @sender_2.send_message(@content, @receiver)

        @sender_1_inbox_list = @sender_1.inbox
        @sender_2_inbox_list = @sender_2.inbox
        @receiver_inbox_list = @receiver.inbox

        @sender_1_exchange_list = @sender_1.short_messages_of_user(@receiver)
        @sender_2_exchange_list = @sender_2.short_messages_of_user(@receiver)
      }

      it "sender_1 收件箱数量正确" do
        @sender_1_inbox_list.count.should == 1
      end

      it "sender_1 收件箱列表顺序正确" do
        @sender_1_inbox_list.should == [@sender_message_1_2]
      end

      it "sender_2 收件箱数量正确" do
        @sender_2_inbox_list.count.should == 1
      end

      it "sender_2 收件箱列表顺序正确" do
        @sender_2_inbox_list.should == [@sender_message_2_2]
      end

      it "receiver 收件箱数量正确" do
        @receiver_inbox_list.count.should == 2
      end

      it "receiver 收件箱列表顺序正确" do
        @receiver_inbox_list.should == [@receiver_message_1_2, @receiver_message_2_2]
      end

      it "sender_1 与 receiver 之间信息列表" do
        @sender_1_exchange_list.should == [
          @sender_message_1_1, 
          @sender_message_1_2, 
          @receiver_message_1_1,
          @receiver_message_1_2
        ]
      end

      it "sender_2 与 receiver 之间信息列表" do
        @sender_2_exchange_list.should == [
          @sender_message_2_1, 
          @sender_message_2_2, 
          @receiver_message_2_1,
          @receiver_message_2_2
        ]
      end


      describe "删除 receiver 收件箱" do

        it "删除 sender_1 不是最前面的条目" do
          @receiver.remove_short_message(@sender_message_1_1)

          @receiver_inbox_list.should == [@sender_message_1_2, @receiver_message_2_2]
        end

        it "删除 sender_1 最前面的条目" do
          @receiver.remove_short_message(@sender_message_1_2)

          @receiver_inbox_list.should == [@sender_message_1_1, @receiver_message_2_2]
        end


        it "删除 sender_2 不是最前面的条目" do
          @receiver.remove_short_message(@sender_message_2_1)

          @receiver_inbox_list.should == [@sender_message_1_2, @sender_message_2_2]
        end

        it "删除 sender_2 最前面的条目" do
          @receiver.remove_short_message(@sender_message_2_2)

          @receiver_inbox_list.should == [@sender_message_1_2, @sender_message_2_1]
        end

      end

      describe "增加 receiver 收件箱" do

        it "sender_1 发送给 receiver" do
          @receiver_message_1_3 = @sender_1.send_message(@content, @receiver)

          @receiver_inbox_list.should == [@sender_message_1_3, @sender_message_2_2]
        end

        it "sender_2 发送给 receiver" do
          @receiver_message_2_3 = @sender_2.send_message(@content, @receiver)

          @receiver_inbox_list.should == [@sender_message_1_2, @sender_message_2_3]
        end

      end

    end

    


  end

  
end