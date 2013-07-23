require 'spec_helper'

describe Report do

  let(:user)      {FactoryGirl.create :user}
  let(:user1)     {FactoryGirl.create :user}
  let(:question)  {FactoryGirl.create :question}
  let(:answer)    {FactoryGirl.create :answer}

  # 举报某个内容
  describe 'user.report(model,desc)' do
    it{
      expect{
        user.report(question,'question error')
      }.to change{Report.count}.by(1)
    }

    it{
      expect{
        user.report(user1,'user1 error')
      }.to change{Report.count}.by(1)
    }

    it{
      expect{
        user.report(answer,'answer error')
      }.to change{Report.count}.by(1)
    }
  end

  #管理员审核举报成功
  describe 'confirm(admin_reply) && reject(admin_reply)' do
    before{
      @report = user.report(question,'question error')
    }

    it{
      @report.confirm('confirm go')
      @report.status.should == 'CONFIRM'
    }

    it{
      @report.reject('reject go')
      @report.status.should == 'REJECT'
    }
  end

  describe 'scope' do
    before{
      @report = user.report(question,'question error')
      @report1 = user.report(answer,'answer error')
    }

    it{
      @report.confirm('confirm go')
      @report1.confirm('confirm go 1')
      Report.confirmed.count.should == 2
    }

    it{
      @report.reject('rejected go')
      Report.rejected.count.should == 1
    }

    it{
      Report.unprocessed.count.should == 2
    }
  end
end