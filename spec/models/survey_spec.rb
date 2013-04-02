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
          @survey_item_str = @survey.survey_items.create(:kind => SurveyItem::Kind::SINGLE_CHOICE, :content => '你的性别?', :choice_options => "男\r\n女" )
        }

        it{
          @survey_item_str.id.blank?.should == false 
        }

        it{
          @survey_item_str.kind.should == SurveyItem::Kind::SINGLE_CHOICE
        }

        it{
          @survey_item_str.choice_options.should == ['男','女'] 
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
      }


      context 'accepts_nested_attributes_for' do
        before{
          @user_3 = FactoryGirl.create(:user)
          @survey_result = @survey.survey_results.build
          @survey_result.creator = @user_3
          survey_result_items_attributes = [
            {:answer => "A", :survey_item_id => @survey_item_1.id},
            {:answer => ["A","C"], :survey_item_id => @survey_item_2.id},
            {:answer => ["111","222"], :survey_item_id => @survey_item_3.id},
            {:answer => "打击好", :survey_item_id => @survey_item_4.id}
          ]
          @survey_result.survey_result_items_attributes = survey_result_items_attributes
          @survey_result.save
        }
        
        it{
          @survey_result.id.blank?.should == false 
        }

        it{
          @survey_result.creator.should == @user_3
        }

        it{
          @survey_result.survey_result_items.first.answer_choice_mask.should == 1 
        }

        it{
          @survey_result.survey_result_items[1].answer_choice_mask.should == 5 
        }

        it{
          @survey_result.survey_result_items[2].answer_fill.should == '111,222'
        }

        it{
          @survey_result.survey_result_items[3].answer_text.should == '打击好'
        }
      end

      context 'validate accepts_nested_attributes_for 1' do
        before{
          @user_3 = FactoryGirl.create(:user)
          @survey_result = @survey.survey_results.build
          @survey_result.creator = @user_3
          survey_result_items_attributes = [
            {:answer => "A", :survey_item_id => @survey_item_1.id+1},
            {:answer => ["A","C"], :survey_item_id => @survey_item_2.id},
            {:answer => ["111","222"], :survey_item_id => @survey_item_3.id},
            {:answer => "打击好", :survey_item_id => @survey_item_4.id}
          ]
          @survey_result.survey_result_items_attributes = survey_result_items_attributes
          @survey_result.save
        }
        
        it{
          @survey_result.id.blank?.should == true
        }
      end

      context 'validate accepts_nested_attributes_for 2' do
        before{
          @user_3 = FactoryGirl.create(:user)
          @survey_result = @survey.survey_results.build
          @survey_result.creator = @user_3
          survey_result_items_attributes = [
            {:answer => ["A","C"], :survey_item_id => @survey_item_2.id},
            {:answer => ["111","222"], :survey_item_id => @survey_item_3.id},
            {:answer => "打击好", :survey_item_id => @survey_item_4.id}
          ]
          @survey_result.survey_result_items_attributes = survey_result_items_attributes
          @survey_result.save
        }
        
        it{
          @survey_result.id.blank?.should == true
        }
      end
    end
  end
end