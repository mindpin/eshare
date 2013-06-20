require "spec_helper"

describe Question do
  describe 'default_scope order id desc' do
    before {
      3.times { FactoryGirl.create(:question) }
      @ids = Question.all.map{|q|q.id}
    }

    it{
      @ids.should == @ids.sort.reverse
    }
  end

  context '#answered_by?' do
    before {
      @question     = FactoryGirl.create :question
      @user         = FactoryGirl.create :user
      @another_user = FactoryGirl.create :user
      @answer       = FactoryGirl.create :answer, :question => @question,
                                                  :creator => @user
    }

    it {
      @question.answered_by?(@user).should == true
    }

    it {
      @question.answered_by?(@another_user).should == false
    }

    it {
      @question.answer_of(@user).should == Answer.last
    }
  end

  describe "检测 updated_at" do
    before {
      Timecop.travel(Time.now - 2.day) do
        @question     = FactoryGirl.create(:question)
      end
      
      @updated_at = @question.updated_at

    }

    it "还没更新时间" do
      @question.updated_at.should == @updated_at
    end

    it "问题被创建者修改" do
      @question.update_attributes({:title => 'test', :content => 'test'})
      @question.updated_at.should > @updated_at
    end

    describe "回答问题" do
      before {
        Timecop.travel(Time.now - 1.day) do
          @answer = FactoryGirl.create(:answer, :question => @question)
        end

        @answered_actived_at = @question.actived_at
      }

      it "问题被任何人回答" do
        @answered_actived_at.should > @updated_at
      end

      it "修改回答" do
        @answer.update_attributes({:content => 'test'})
        @question.actived_at.should > @answered_actived_at
      end

    end

  end

  describe "匿名数据检查" do
    before {
      3.times { FactoryGirl.create :question, :is_anonymous => true }
      2.times { FactoryGirl.create :question, :is_anonymous => false }
    }

    it "匿名数目" do
      Question.anonymous.count.should == 3
    end

    it "is_anonymous 为 true" do
      Question.anonymous.each { |q| q.is_anonymous.should == true }
    end


    it "非匿名数目" do
      Question.onymous.count.should == 2
    end

    it "is_anonymous 为 false" do
      Question.onymous.each { |q| q.is_anonymous.should == false }
    end

  end

  describe 'question 多态关联 课程/课件/章节' do
    before{
      @course = FactoryGirl.create(:course)
      @chapter = FactoryGirl.create(:chapter, :course => @course)
      @course_ware = FactoryGirl.create(:course_ware, :chapter => @chapter)
    }

    it{
      question = FactoryGirl.create(:question, :course => @course)
      question.reload
      question.course.should == @course
      question.chapter.should == nil
      question.course_ware.should == nil
    }

    it{
      question = FactoryGirl.create(:question, :chapter => @chapter)
      question.reload
      question.course.should == @course
      question.chapter.should == @chapter
      question.course_ware.should == nil
    }

    it{
      question = FactoryGirl.create(:question, :course_ware => @course_ware)
      question.reload
      question.course.should == @course
      question.chapter.should == @chapter
      question.course_ware.should == @course_ware
    }

    it{
      question = FactoryGirl.create(:question)
      question.reload
      question.course.should == nil
    }
  end

  describe 'question.answers.count 和 question.answers_count 同步' do
    before {
      @user = FactoryGirl.create(:user)
      Timecop.travel(Time.now - 2.day) do
        @question   = FactoryGirl.create(:question)
        @updated_at = @question.updated_at
      end
      
    }

    it{
      @question.answers.count.should == @question.answers_count
    }

    it{
      @question.answers.create!(:creator => @user, :content => "1")
      @question.reload
      @question.answers.count.should == 1
      @question.answers_count.should == 1
      @question.updated_at.to_i.should == @updated_at.to_i
    }

  end
end

describe Answer do
  describe 'Validation' do
    before {
      @user = FactoryGirl.create :user
      @answer = FactoryGirl.create :answer
    }

    it {
      @answer.vote_sum.should == 0
    }

    it "没有投过票" do
      @answer.has_voted_by?(@user).should == false
    end

    it "已经投过票" do
      @vote = FactoryGirl.create :answer_vote, :user => @user, 
                                               :answer => @answer
      @answer.has_voted_by?(@user).should == true
    end

    it "用户的投票记录" do
      @vote = FactoryGirl.create :answer_vote, :user => @user, 
                                               :answer => @answer,
                                               :kind => 'VOTE_UP'
      @vote.kind.should == 'VOTE_UP'
      @vote.answer.should == @answer
      @vote.user.should == @user
    end

    context '赞成票' do
      it do
        expect {
          @vote = FactoryGirl.create :answer_vote, :user => @user, 
                                                   :answer => @answer,
                                                   :kind => 'VOTE_UP'
        }.to change {
          @answer.vote_sum
        }.by(1)
      end

      it {
        @answer.vote_up_by!(@user)
        @answer.vote_down_by!(@user)
        @answer.answer_votes.by_user(@user).count.should == 1
      }

      it {
        expect {
          @answer.vote_up_by!(@user)
        }.to change {
          @answer.vote_sum
        }.by(1)
      }

      it {
        @answer.vote_up_by!(@user)
        @answer.answer_votes.by_user(@user).count.should == 1
      }
    end
    
    context '反对票' do
      it do
        expect {
          @vote = FactoryGirl.create :answer_vote, :user => @user, 
                                                   :answer => @answer,
                                                   :kind => 'VOTE_DOWN'
        }.to change {
          @answer.vote_sum
        }.by(-1)
      end

      it {
        expect {
          @answer.vote_down_by!(@user)
        }.to change {
          @answer.vote_sum
        }.by(-1)
      }

      it {
        @answer.vote_down_by!(@user)
        @answer.answer_votes.by_user(@user).count.should == 1
      }
    end

    context '被不同人反复投票' do
      before {
        @user_a = FactoryGirl.create(:user)
        @user_b = FactoryGirl.create(:user)
      }

      it {
        expect {
          @answer.vote_down_by! @user 

          @answer.vote_down_by! @user_a
          @answer.vote_down_by! @user_a

          @answer.vote_down_by! @user_b
          @answer.vote_up_by! @user_b

          @answer.vote_up_by! @user

          @answer.vote_up_by! FactoryGirl.create(:user)

          # 最终结果
          # @user +1
          # @user_a -1
          # @user_b +1
          # another_user +1
        }.to change {
          @answer.vote_sum
        }.by(+1-1+1+1)
      }
    end

    context '取消投票' do
      it {
        expect {
          @answer.vote_down_by! @user 
          @answer.vote_cancel_by! @user
        }.to change {
          @answer.vote_sum
        }.by(0)
      }
    end
  end

  describe "匿名数据检查" do
    before {
      5.times { FactoryGirl.create :answer, :is_anonymous => true }
      6.times { FactoryGirl.create :answer, :is_anonymous => false }
    }

    it "匿名数目" do
      Answer.anonymous.count.should == 5
    end

    it "is_anonymous 为 true" do
      Answer.anonymous.each { |a| a.is_anonymous.should == true }
    end


    it "非匿名数目" do
      Answer.onymous.count.should == 6
    end

    it "is_anonymous 为 false" do
      Answer.onymous.each { |a| a.is_anonymous.should == false }
    end
  end
end

describe AnswerVote do
  context('Validation') {
    before {
      @question     = FactoryGirl.create :question
      @answer_user         = FactoryGirl.create :user
      @vote_user         = FactoryGirl.create :user

      Timecop.travel(Time.now - 2.day) do
        @answer       = FactoryGirl.create :answer, :question => @question,
                                                  :creator => @answer_user
      end

      @answer_updated_at = @answer.updated_at
    }

    it {
      vote = AnswerVote.new :answer => @answer,
                            :user => @vote_user
      vote.valid?.should == false
    }

    context {
      before { 
        @vote = @answer.answer_votes.create :user => @vote_user
      }

      it { @vote.valid?.should == false }
      it { AnswerVote.count.should == 0 }
    }

    context {
      before {
        @vote = @answer.answer_votes.create :user => @vote_user
        @vote.update_attribute :kind, 'VOTE_DOWN'

        @answer.reload
      }
      it { @vote.valid?.should == true }
      it { AnswerVote.count.should == 1 }

      it "答案投票, updated_at 不更新" do
        @answer.updated_at.to_i.should == @answer_updated_at.to_i
      end
    }

    context "不能对自己的回答进行投票" do

      before {
        @vote = @answer.answer_votes.create :user => @answer_user
        @vote.kind = 'VOTE_UP'
        @vote.save
      }

      it { @vote.valid?.should == false }
      it { AnswerVote.count.should == 0 }

      it "vote_up_by! 无记录" do
        @answer.vote_up_by! @answer_user

        AnswerVote.count.should == 0
      end

      it "vote_down_by! 无记录" do
        @answer.vote_down_by! @answer_user

        AnswerVote.count.should == 0
      end

      it "vote_cancel_by! 无记录" do
        @answer.vote_cancel_by! @answer_user

        AnswerVote.count.should == 0
      end
      
    end

    context {
      before {
        @vote = @answer.answer_votes.create :user => @vote_user
        @vote.update_attributes :kind => 'XXXX'
        # udpate_attribute 方法不会触发校验
      }
      it { @vote.valid?.should == false }
      it { AnswerVote.count.should == 0 }
    }
  }

  context '答案投票的级联删除' do
    before {
      @answer = FactoryGirl.create :answer
      5.times do
        vote = FactoryGirl.create :answer_vote, :answer => @answer
      end
    }

    it {
      Answer.count.should == 1
    }

    it {
      @answer.answer_votes.count.should == 5
    }

    it {
      @answer.destroy
      Answer.count.should == 0
    }

    it {
      @answer.destroy
      AnswerVote.count.should == 0
    }
  end
end





describe "最佳答案" do
  before {
    @question     = FactoryGirl.create :question
    @answer     = FactoryGirl.create :answer, :question => @question

    @question.update_attributes({:best_answer => @answer})
    @question.reload

    @origin_best_answer  = @question.best_answer


    @answer_1     = FactoryGirl.create :answer
    @answer_2     = FactoryGirl.create :answer, :question => @question

  }

  describe "用其它问题答案赋值" do
    before {
      @question.best_answer = @answer_1
      @question.save
      @question.reload
    }

    it "不能是其它问题的答案" do
      @question.best_answer.should_not == @answer_1
    end
    

    it "应该还是原来的值" do
      @question.best_answer.should == @origin_best_answer
    end
    
  end

  describe "用自己问题答案赋值" do
    before {
      @question.best_answer =  @answer_2
      @question.save
    }

    it "应该是自己问题的答案" do
      @question.best_answer.should == @answer_2
    end
    

    it "应该不是原来的值" do
      @question.best_answer.should_not == @origin_best_answer
    end
  end
end

describe "有最佳答案的问题列表" do
  before {
    @question_1   = FactoryGirl.create :question
    @answer_1     = FactoryGirl.create :answer, :question => @question_1

    @question_1.best_answer = @answer_1
    @question_1.save
    @question_1.reload

    @question_2   = FactoryGirl.create :question
    @answer_2     = FactoryGirl.create :answer, :question => @question_2
    @question_2.best_answer = @answer_2
    @question_2.save
    @question_2.reload

    @question_3   = FactoryGirl.create :question
    @answer_3     = FactoryGirl.create :answer, :question => @question_3
    @question_3.best_answer = @answer_3
    @question_3.save
    @question_3.reload

    3.times { FactoryGirl.create :question }

    @questions_with_best_answer = Question.has_best_answer
  }

  it "总的数量正确" do
    Question.count.should == 6
  end

  it "有最佳答案的问题数量正确" do
    @questions_with_best_answer.count.should == 3
  end

  it "列表正确" do
    @questions_with_best_answer.should == [@question_3, @question_2, @question_1]
  end
end

describe '问题的 actived_at 更新' do
  before {
    @question = FactoryGirl.create :question

    @updated_at = @question.updated_at
    @actived_at = @question.actived_at
  }

  it {
    @actived_at.should_not be_blank
  }

  it('创建回答') {
    Timecop.travel(@actived_at + 1.day) do
      FactoryGirl.create :answer, :question => @question
    end

    @question.actived_at.should > @actived_at
    @question.updated_at.should == @updated_at
  }

  it('修改问题') {
    Timecop.travel(@actived_at + 1.day) do
      @question.update_attributes({
        :title => 'foobar'  
      })
    end

    @question.actived_at.should > @actived_at
    @question.updated_at.should > @updated_at
  }
end

describe 'answer.has_voted_up_by? answer.has_voted_down_by?' do
  before {
    @answer = FactoryGirl.create :answer
    @user = FactoryGirl.create :user
  }

  it {
    @answer.has_voted_up_by?(@user).should == false
    @answer.has_voted_down_by?(@user).should == false
  }

  it {
    @answer.vote_up_by! @user
    @answer.has_voted_up_by?(@user).should == true
    @answer.has_voted_down_by?(@user).should == false
  }

  it {
    @answer.vote_down_by! @user
    @answer.has_voted_up_by?(@user).should == false
    @answer.has_voted_down_by?(@user).should == true
  }
end