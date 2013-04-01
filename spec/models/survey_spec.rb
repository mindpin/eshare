require 'spec_helper'

describe Survey do
  describe '创建调查问卷' do
    before{
      @user = FactoryGirl.create(:user)
      @survey = @user.surveys.create(:title => '标题')
    }

    it{
      @survey.id.blank?.should == false
    }

    describe '给调查问卷增加单选类型的问题' do
      before{
        @survey_item = @survey.survey_items.create(:kind => SurveyItem::Kind::SINGLE_CHOICE, :content => '你的性别?', :choice_options => ['男','女'] )
      }

      it{
        @survey_item.id.blank?.should == false 
      }

      it{
        @survey_item.kind.should == SurveyItem::Kind::SINGLE_CHOICE
      }

      it{
        @survey_item.choice_options.should == ['男','女'] 
      }

      context 'choice_options_str' do
        before{
          @survey_item_str = @survey.survey_items.create(:kind => SurveyItem::Kind::SINGLE_CHOICE, :content => '你的性别?', :choice_options_str => "男\r\n女" )
        }

        it{
          @survey_item.id.blank?.should == false 
        }

        it{
          @survey_item.kind.should == SurveyItem::Kind::SINGLE_CHOICE
        }

        it{
          @survey_item.choice_options.should == ['男','女'] 
        }
      end
    end

    describe '给调查问卷增加多选类型的问题' do
      before{
        @survey_item = @survey.survey_items.create(:kind => SurveyItem::Kind::MULTIPLE_CHOICE, :content => '你喜欢的水果?', :choice_options => ['苹果','橘子','梨','其他'])
      }

      it{
        @survey_item.id.blank?.should == false
      }

      it{
        @survey_item.kind.should == SurveyItem::Kind::MULTIPLE_CHOICE
      }

      it{
        @survey_item.choice_options.should == ['苹果','橘子','梨','其他']
      }
    end

    describe '给调查问卷增加填空类型的问题' do
      before{
        @survey_item = @survey.survey_items.create(:kind => SurveyItem::Kind::FILL, :content => '你的姓名*，你的电话*')
      }

      it{
        @survey_item.id.blank?.should == false 
      }

      it{
        @survey_item.kind.should == SurveyItem::Kind::FILL
      }

      it{
        @survey_item.content_by_replace('__').should == '你的姓名__，你的电话__'
      }
    end

    describe '给调查问卷增加问答类型的问题' do
      before{
        @survey_item = @survey.survey_items.create(:kind => SurveyItem::Kind::TEXT, :content => '你有什么建议么？')
      }

      it{
        @survey_item.id.blank?.should == false 
      }

      it{
        @survey_item.kind.should == SurveyItem::Kind::TEXT
      }
    end

    describe '增加多个问题，在进行回答' do
      before{
        @survey_item_1 = @survey.survey_items.create(:kind => SurveyItem::Kind::SINGLE_CHOICE, :content => '你的性别?', :choice_options => ['男','女'] )
        @survey_item_2 = @survey.survey_items.create(:kind => SurveyItem::Kind::MULTIPLE_CHOICE, :content => '你喜欢的水果?', :choice_options => ['苹果','橘子','梨','其他'])
        @survey_item_3 = @survey.survey_items.create(:kind => SurveyItem::Kind::FILL, :content => '你的姓名*，你的电话*')
        @survey_item_4 = @survey.survey_items.create(:kind => SurveyItem::Kind::TEXT, :content => '你有什么建议么？')

        @survey_item_1.id.blank?.should == false
        @survey_item_2.id.blank?.should == false
        @survey_item_3.id.blank?.should == false
        @survey_item_4.id.blank?.should == false

        @survey_result = @survey.survey_results.build
        @survey_result.creator = @user
        @survey_result.save
      }

      it{
        @survey_result.id.blank?.should == false 
      }

      it{
        @survey.survey_results.count.should == 1
      }

      context '回答第一个问题' do
        before{
          @result_item_1 = @survey_result.survey_result_items.build
          @result_item_1.answer = 'A'
          @result_item_1.survey_item = @survey_item_1
          @result_item_1.save
        }

        it{
          @result_item_1.answer_choice_mask.should == 1
        }

        context '回答第二个问题' do
          before{
            @result_item_2 = @survey_result.survey_result_items.build
            @result_item_2.answer = 'AC'
            @result_item_2.survey_item = @survey_item_2
            @result_item_2.save
          }

          it{
            @result_item_2.answer_choice_mask.should == 5
          }
          context '回答第三个问题' do
            before{
              @result_item_3 = @survey_result.survey_result_items.build
              @result_item_3.answer = 'fushang318,110'
              @result_item_3.survey_item = @survey_item_3
              @result_item_3.save
            }

            it{
              @result_item_3.answer_fill.should == 'fushang318,110'
            }
            context '回答第四个问题' do
              before{
                @result_item_4 = @survey_result.survey_result_items.build
                @result_item_4.answer = '没有建议，一切都好'
                @result_item_4.survey_item = @survey_item_4
                @result_item_4.save
              }

              it{
                @result_item_4.answer_text.should == '没有建议，一切都好'
              }
            end
          end
        end
      end

    end
  end
end