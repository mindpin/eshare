require 'spec_helper'

describe Practice do

  describe "创建单一习题" do

    before {
      # 创建习题
      @creator = FactoryGirl.create(:user)

      # 用于提交习题
      @user_1 = FactoryGirl.create(:user)

      # 用于批阅习题
      @user_2 = FactoryGirl.create(:user)

      @chapter = FactoryGirl.create(:chapter)
      @practice = FactoryGirl.create(:practice)
      @file_entity = FactoryGirl.create(:file_entity)
    }

    it "创建习题" do
      expect{
        @chapter.practices.create(:title => '标题', :content => "内容", :creator => @creator)
      }.to change{Practice.count}.by(1)
    end

    it "习题还未有任何提交" do
      @practice.records.count.should == 0
    end

    it "应该还没提交" do
      @practice.is_submit_by_user?(@user_1).should == false
      @practice.is_submit_by_user?(@user_2).should == false
      @practice.is_submit_by_user?(@creator).should == false
    end


    it "创建习题附件" do
      expect{
        @practice.attaches.create(:file_entity => @file_entity, :name => "附件")
      }.to change{PracticeAttach.count}.by(1)
    end

    it "创建习题提交物要求" do
      expect{
        @practice.requirements.create(:content => "要求")
      }.to change{PracticeRequirement.count}.by(1)
    end



    describe "提交习题" do
      before {
        @time = Time.now

        Timecop.freeze(@time) do
          @practice.submit_by_user(@user_1)
        end
      }

      it "已经提交" do
        @practice.is_submit_by_user?(@user_1).should == true
      end

      it "还没被批阅" do
        @practice.is_checked_by_user?(@user_2).should == false
      end

      it "提交时间正确" do
        @practice.submitted_time_by_user(@user_1).should == @time
      end

      it "批阅时间为空" do
        @practice.checked_time_by_user(@user_2).should == ""
      end


      describe '批阅习题' do
        before {
          sleep(1)

          @time = Time.now

          Timecop.freeze(@time) do
            @practice.check_by_user(@user_2)
          end
          
        }

        it "已经被批阅" do
          @practice.is_checked_by_user?(@user_2).should == true
        end

        it "批阅时间正确" do
          @practice.checked_time_by_user(@user_2).should == @time
        end
      end
      
    end


    

  end


  describe "创建习题时连同创建多个附件" do
    before {
      @user = FactoryGirl.create(:user)
      @chapter = FactoryGirl.create(:chapter)
      @file_entity_1 = FactoryGirl.create(:file_entity)
      @file_entity_2 = FactoryGirl.create(:file_entity)
      
      attaches_attributes = [
        {:file_entity => @file_entity_1, :name => '附件1'},
        {:file_entity => @file_entity_2, :name => '附件2'}
      ]

      @practice = @chapter.practices.create(
        :title => '标题', 
        :content => "内容",
        :creator => @user,
        :attaches_attributes => attaches_attributes
      )

    }

    it "practice 创建成功" do
      @practice.id.blank?.should == false
    end

    it "习题附件数量正确" do 
      @practice.attaches.count.should == 2    
    end

  end



  describe "创建习题时连同创建多个要求" do
    before {
      @user = FactoryGirl.create(:user)
      @chapter = FactoryGirl.create(:chapter)
      
      requirements_attributes = [
        {:content => '要求1'},
        {:content => '要求2'}
      ]

      @practice = @chapter.practices.create(
        :title => '标题', 
        :content => '内容',
        :creator => @user,
        :requirements_attributes => requirements_attributes
      )

      @requirement = @practice.requirements.first

      @file_entity_1 = FactoryGirl.create(:file_entity)
      @file_entity_2 = FactoryGirl.create(:file_entity)

      @upload_params_1 = {:file_entity => @file_entity_1, :name => '提交物1', :creator => @user}
      @upload_params_2 = {:file_entity => @file_entity_2, :name => '提交物2', :creator => @user}

      @requirement.uploads.create(@upload_params_1)
      @requirement.uploads.create(@upload_params_2)
    }

    it "practice 创建成功" do
      @practice.id.blank?.should == false
    end

    it "习题附件数量正确" do 
      @practice.requirements.count.should == 2    
    end

    it "习题提交物数量" do
      @requirement.uploads.count.should == 2
    end

  end

  
end