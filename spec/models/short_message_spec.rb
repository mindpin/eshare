require "spec_helper"

describe ShortMessage do

  describe "发送信息" do

    before {
      @sender = FactoryGirl.create :user
      @receiver = FactoryGirl.create :user
      @content = "content"

      @sender.send_message(@content, @receiver)
      @message = ShortMessage.last    
    }

    it "sender 收件箱数量正确" do
      @sender.inbox.count.should == 1
    end

    it "receiver 收件箱数量正确" do
      @receiver.inbox.count.should == 1
    end

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

    describe "sender 删除信息" do
      before {
        @message = @sender.remove_short_message(@message)
      }
      
      it "删除状态为 true" do
        @message.sender_hide.should == true
      end

      it "收件箱数量正确" do
        @sender.inbox.count.should == 0
      end
      
    end

    it "接收者还未曾删除" do
      @message.receiver_hide.should == false
    end

    describe "receiver 删除信息" do
      before {
        @message = @receiver.remove_short_message(@message)
      }
      
      it "删除状态为 true" do
        @message.receiver_hide.should == true
      end

      it "收件箱数量正确" do
        @receiver.inbox.count.should == 0
      end
      
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
        @message_1 = @sender_1.send_message(@content, @receiver)
        @message_2 = @sender_1.send_message(@content, @receiver)
        @message_3 = @sender_1.send_message(@content, @receiver)

        @inbox_list = @receiver.inbox
        @sender_1_exchange_list = @sender_1.short_messages_of_user(@receiver)

      }

      it "收件箱数量正确" do
        @inbox_list.count.should == 1
      end

      it "收件箱列表顺序正确" do
        @inbox_list.should == [@message_3]
      end

      it "发送者 与 接收者 对话列表" do
        @sender_1_exchange_list.should == [@message_3, @message_2, @message_1]
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

        @sender_1_exchange_list = @sender_1.short_messages_of_user(@receiver)
        @receiver_exchange_list = @receiver.short_messages_of_user(@sender_1)
      }

      it "sender 收件箱数量正确" do
        @sender_inbox_list.count.should == 1
      end

      it "sender 收件箱列表顺序正确" do
        @sender_inbox_list.should == [@message_4]
      end

      it "receiver 收件箱数量正确" do
        @receiver_inbox_list.count.should == 1
      end

      it "receiver 收件箱列表顺序正确" do
        @receiver_inbox_list.should == [@message_4]
      end

      it "sender_1 与 receiver 对话列表" do
        @sender_1_exchange_list.should == [@message_4, @message_3, @message_2, @message_1]
      end

      it "receiver 与 sender_1 对话列表" do
        @receiver_exchange_list.should == [@message_4, @message_3, @message_2, @message_1]
      end

    end


    describe "二个发送者 对 一个接收者 单方向发送信息" do

      before {
        @message_1_1 = @sender_1.send_message(@content, @receiver)
        @message_1_2 = @sender_1.send_message(@content, @receiver)
        @message_1_3 = @sender_1.send_message(@content, @receiver)
        @message_1_4 = @sender_1.send_message(@content, @receiver)

        @message_2_1 = @sender_2.send_message(@content, @receiver)
        @message_2_2 = @sender_2.send_message(@content, @receiver)
        @message_2_3 = @sender_2.send_message(@content, @receiver)
        @message_2_4 = @sender_2.send_message(@content, @receiver)

        @inbox_list = @receiver.inbox

        @sender_1_exchange_list = @sender_1.short_messages_of_user(@receiver)
        @sender_2_exchange_list = @sender_2.short_messages_of_user(@receiver)
      }

      it "收件箱数量正确" do
        @inbox_list.count.should == 2
      end

      it "收件箱列表顺序正确" do
        @inbox_list.should == [@message_2_4, @message_1_4]
      end

      it "sender_1 与 receiver 对话列表" do
        @sender_1_exchange_list.should == [@message_1_4, @message_1_3, @message_1_2, @message_1_1]
      end

      it "sender_2 与 receiver 对话列表" do
        @sender_2_exchange_list.should == [@message_2_4, @message_2_3, @message_2_2, @message_2_1]
      end

    end


    describe "二个发送者 和 一个接收者 互相 发送信息" do

      before {
        @message_1_1 = @receiver.send_message(@content, @sender_1)
        @message_1_2 = @receiver.send_message(@content, @sender_1)
        @message_1_3 = @sender_1.send_message(@content, @receiver)
        @message_1_4 = @sender_1.send_message(@content, @receiver)

        @message_2_1 = @receiver.send_message(@content, @sender_2)
        @message_2_2 = @receiver.send_message(@content, @sender_2)
        @message_2_3 = @sender_2.send_message(@content, @receiver)
        @message_2_4 = @sender_2.send_message(@content, @receiver)

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
        @sender_1_inbox_list.should == [@message_1_4]
      end

      it "sender_2 收件箱数量正确" do
        @sender_2_inbox_list.count.should == 1
      end

      it "sender_2 收件箱列表顺序正确" do
        @sender_2_inbox_list.should == [@message_2_4]
      end

      it "receiver 收件箱数量正确" do
        @receiver_inbox_list.count.should == 2
      end

      it "receiver 收件箱列表顺序正确" do
        @receiver_inbox_list.should == [@message_2_4, @message_1_4]
      end

      it "sender_1 与 receiver 之间信息列表" do
        @sender_1_exchange_list.should == [
          @message_1_4,
          @message_1_3,
          @message_1_2,
          @message_1_1 
        ]
      end

      it "sender_2 与 receiver 之间信息列表" do
        @sender_2_exchange_list.should == [
          @message_2_4,
          @message_2_3,
          @message_2_2, 
          @message_2_1
        ]
      end


      describe "删除 receiver 收件箱" do

        describe "sender_1 删除" do
          it "删除不是最前面的条目1" do
            @receiver.remove_short_message(@message_1_1)
            @receiver_inbox_list = @receiver.inbox

            @receiver_inbox_list.should == [@message_2_4, @message_1_4]
          end

          it "删除不是最前面的条目2" do
            @receiver.remove_short_message(@message_1_2)
            @receiver_inbox_list = @receiver.inbox

            @receiver_inbox_list.should == [@message_2_4, @message_1_4]
          end

          it "删除不是最前面的条目3" do
            @receiver.remove_short_message(@message_1_3)
            @receiver_inbox_list = @receiver.inbox

            @receiver_inbox_list.should == [@message_2_4, @message_1_4]
          end

          it "删除最前面的条目" do
            @receiver.remove_short_message(@message_1_4)
            @receiver_inbox_list = @receiver.inbox

            @receiver_inbox_list.should == [@message_2_4, @message_1_3]
          end
        end

        


        describe "sender_2 删除" do
          it "删除不是最前面的条目1" do
            @receiver.remove_short_message(@message_2_1)
            @receiver_inbox_list = @receiver.inbox

            @receiver_inbox_list.should == [@message_2_4, @message_1_4]
          end

          it "删除不是最前面的条目2" do
            @receiver.remove_short_message(@message_2_2)
            @receiver_inbox_list = @receiver.inbox

            @receiver_inbox_list.should == [@message_2_4, @message_1_4]
          end

          it "删除不是最前面的条目3" do
            @receiver.remove_short_message(@message_2_3)
            @receiver_inbox_list = @receiver.inbox

            @receiver_inbox_list.should == [@message_2_4, @message_1_4]
          end

          it "删除最前面的条目" do
            @receiver.remove_short_message(@message_2_4)
            @receiver_inbox_list = @receiver.inbox

            @receiver_inbox_list.should == [@message_2_3, @message_1_4]
          end
        end

      end

      describe "增加 receiver 收件箱" do

        it "sender_1 发送给 receiver" do
          @message_1_5 = @sender_1.send_message(@content, @receiver)
          @receiver_inbox_list = @receiver.inbox

          @receiver_inbox_list.should == [@message_1_5, @message_2_4]
        end

        it "sender_2 发送给 receiver" do
          @message_2_5 = @sender_2.send_message(@content, @receiver)
          @receiver_inbox_list = @receiver.inbox

          @receiver_inbox_list.should == [@message_2_5, @message_1_4]
        end

      end

    end

    


  end

  
end