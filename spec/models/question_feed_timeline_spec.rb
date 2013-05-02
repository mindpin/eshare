require 'spec_helper'

describe QuestionFeedTimelime do
  context 'db' do
    before{
      # 两个用户
      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
      @user_3 = FactoryGirl.create(:user)
      # 两个问题
      @question_1 = FactoryGirl.create(:question, :creator => @user_1)
      @question_2 = FactoryGirl.create(:question, :creator => @user_2)

    }

    it{
      @user_3.question_feed_timeline_db.should == []
    }

    it{
      @user_1.question_feed_timeline_db.map(&:to).should == [@question_1]
    }

    it{
      @user_2.question_feed_timeline_db.map(&:to).should == [@question_2]
    }

    it{
      @question_1.question_feed_timeline_db.map(&:to).should == [@question_1]
    }

    it{
      @question_2.question_feed_timeline_db.map(&:to).should == [@question_2]
    }

    context '回答问题' do
      before{
        # user_1 回答 question_2
        @answer12 = FactoryGirl.create :answer, :question => @question_2,
                                                :creator => @user_1
        # user_2 回答 question_1
        @answer21 = FactoryGirl.create :answer, :question => @question_1,
                                                :creator => @user_2
        # user_3 回答 question_1
        @answer31 = FactoryGirl.create :answer, :question => @question_1,
                                                :creator => @user_3
        # user_3 回答 question_2
        @answer32 = FactoryGirl.create :answer, :question => @question_2,
                                                :creator => @user_3
      }

      it{
        @user_3.question_feed_timeline_db.map(&:to).should == [
          @answer32,  @answer31
        ]
      }

      it{
        @user_1.question_feed_timeline_db.map(&:to).should == [
          @answer12, @question_1
        ]
      }

      it{
        @user_2.question_feed_timeline_db.map(&:to).should == [
          @answer21, @question_2
        ]
      }

      it{
        @question_1.question_feed_timeline_db.map(&:to).should == [
          @answer31, @answer21, @question_1
        ]
      }

      it{
        @question_2.question_feed_timeline_db.map(&:to).should == [
          @answer32, @answer12, @question_2
        ]
      }

      context '投赞同票' do
        before{
          # user_1 支持 user_3 对 question_1 的答案
          @answer31.vote_up_by!(@user_1)
          @vote_1 = @answer31.answer_votes.by_user(@user_1).last
          # user_2 支持 user_3 对 question_2 的答案
          @answer32.vote_up_by!(@user_2)
          @vote_2 = @answer32.answer_votes.by_user(@user_2).last
        }

        it{
          @user_3.question_feed_timeline_db.map(&:to).should == [
            @answer32,  @answer31
          ]
        }

        it{
          @user_1.question_feed_timeline_db.map(&:to).should == [
            @vote_1, @answer12, @question_1
          ]
        }

        it{
          @user_2.question_feed_timeline_db.map(&:to).should == [
            @vote_2, @answer21, @question_2
          ]
        }

        it{
          @question_1.question_feed_timeline_db.map(&:to).should == [
            @vote_1, @answer31, @answer21, @question_1
          ]
        }

        it{
          @question_2.question_feed_timeline_db.map(&:to).should == [
            @vote_2, @answer32, @answer12, @question_2
          ]
        }

        context '投反对票' do
          before{
            # user_2 反对 user_3 对 question_2 的答案
            @answer32.vote_down_by!(@user_2)
          }

          it{
            @user_3.question_feed_timeline_db.map(&:to).should == [
              @answer32,  @answer31
            ]
          }

          it{
            @user_1.question_feed_timeline_db.map(&:to).should == [
              @vote_1, @answer12, @question_1
            ]
          }

          it{
            @user_2.question_feed_timeline_db.map(&:to).should == [
              @answer21, @question_2
            ]
          }

          it{
            @question_1.question_feed_timeline_db.map(&:to).should == [
              @vote_1, @answer31, @answer21, @question_1
            ]
          }

          it{
            @question_2.question_feed_timeline_db.map(&:to).should == [
              @answer32, @answer12, @question_2
            ]
          }

          context 'user_2 再次赞同 user_3 对 question_2 的答案' do
            before{
              @answer32.vote_up_by!(@user_2)
              @vote_3 = @answer32.answer_votes.by_user(@user_2).last
            }

            it{
              @user_3.question_feed_timeline_db.map(&:to).should == [
                @answer32,  @answer31
              ]
            }

            it{
              @user_1.question_feed_timeline_db.map(&:to).should == [
                @vote_1, @answer12, @question_1
              ]
            }

            it{
              @user_2.question_feed_timeline_db.map(&:to).should == [
                @vote_3, @answer21, @question_2
              ]
            }

            it{
              @question_1.question_feed_timeline_db.map(&:to).should == [
                @vote_1, @answer31, @answer21, @question_1
              ]
            }

            it{
              @question_2.question_feed_timeline_db.map(&:to).should == [
                @vote_3, @answer32, @answer12, @question_2
              ]
            }
          end
        end

      end
    end
  end

  context 'redis' do
    it{
      # 两个用户
      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
      @user_3 = FactoryGirl.create(:user)
      # 两个问题
      @question_1 = FactoryGirl.create(:question, :creator => @user_1)
      @question_2 = FactoryGirl.create(:question, :creator => @user_2)

      # 第一轮测试
      @user_3.question_feed_timeline.should == []
      @user_1.question_feed_timeline.map(&:to).should == [@question_1]
      @user_2.question_feed_timeline.map(&:to).should == [@question_2]
      @question_1.question_feed_timeline.map(&:to).should == [@question_1]
      @question_2.question_feed_timeline.map(&:to).should == [@question_2]
      

      ## 回答问题
      # user_1 回答 question_2
      @answer12 = FactoryGirl.create :answer, :question => @question_2,
                                              :creator => @user_1
      # user_2 回答 question_1
      @answer21 = FactoryGirl.create :answer, :question => @question_1,
                                              :creator => @user_2
      # user_3 回答 question_1
      @answer31 = FactoryGirl.create :answer, :question => @question_1,
                                              :creator => @user_3
      # user_3 回答 question_2
      @answer32 = FactoryGirl.create :answer, :question => @question_2,
                                              :creator => @user_3
      
      @user_3.question_feed_timeline.map(&:to).should == [
        @answer32,  @answer31
      ]

      @user_1.question_feed_timeline.map(&:to).should == [
        @answer12, @question_1
      ]

      @user_2.question_feed_timeline.map(&:to).should == [
        @answer21, @question_2
      ]

      @question_1.question_feed_timeline.map(&:to).should == [
        @answer31, @answer21, @question_1
      ]

      @question_2.question_feed_timeline.map(&:to).should == [
        @answer32, @answer12, @question_2
      ]


      ### 投赞同票
      # user_1 支持 user_3 对 question_1 的答案
      @answer31.vote_up_by!(@user_1)
      @vote_1 = @answer31.answer_votes.by_user(@user_1).last
      # user_2 支持 user_3 对 question_2 的答案
      @answer32.vote_up_by!(@user_2)
      @vote_2 = @answer32.answer_votes.by_user(@user_2).last
      
      @user_3.question_feed_timeline.map(&:to).should == [
        @answer32,  @answer31
      ]

      @user_1.question_feed_timeline.map(&:to).should == [
        @vote_1, @answer12, @question_1
      ]

      @user_2.question_feed_timeline.map(&:to).should == [
        @vote_2, @answer21, @question_2
      ]

      @question_1.question_feed_timeline.map(&:to).should == [
        @vote_1, @answer31, @answer21, @question_1
      ]

      @question_2.question_feed_timeline.map(&:to).should == [
        @vote_2, @answer32, @answer12, @question_2
      ]


      ## 投反对票
      # user_2 反对 user_3 对 question_2 的答案
      @answer32.vote_down_by!(@user_2)

      @user_3.question_feed_timeline.map(&:to).should == [
        @answer32,  @answer31
      ]

      @user_1.question_feed_timeline.map(&:to).should == [
        @vote_1, @answer12, @question_1
      ]

      @user_2.question_feed_timeline.map(&:to).should == [
        @answer21, @question_2
      ]

      @question_1.question_feed_timeline.map(&:to).should == [
        @vote_1, @answer31, @answer21, @question_1
      ]

      @question_2.question_feed_timeline.map(&:to).should == [
        @answer32, @answer12, @question_2
      ]

      ## user_2 再次赞同 user_3 对 question_2 的答案
      @answer32.vote_up_by!(@user_2)
      @vote_3 = @answer32.answer_votes.by_user(@user_2).last
      
      @user_3.question_feed_timeline.map(&:to).should == [
        @answer32,  @answer31
      ]

      @user_1.question_feed_timeline.map(&:to).should == [
        @vote_1, @answer12, @question_1
      ]

      @user_2.question_feed_timeline.map(&:to).should == [
        @vote_3, @answer21, @question_2
      ]

      @question_1.question_feed_timeline.map(&:to).should == [
        @vote_1, @answer31, @answer21, @question_1
      ]

      @question_2.question_feed_timeline.map(&:to).should == [
        @vote_3, @answer32, @answer12, @question_2
      ]

    }
  end
end