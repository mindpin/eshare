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
  end
end