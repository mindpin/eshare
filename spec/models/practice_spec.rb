require 'spec_helper'

describe Practice do

  describe "创建单一习题" do

    before {

      @user = FactoryGirl.create(:user)

      @chapter = FactoryGirl.create(:chapter)
      @practice = FactoryGirl.create(:practice)
      @file_entity = FactoryGirl.create(:file_entity)
    }

    it "创建习题" do
      expect{
        @chapter.practices.create(:title => '标题', :content => "内容", :creator => @user)
      }.to change{Practice.count}.by(1)
    end

    it "习题还未有任何提交" do
      @practice.records.count.should == 0
    end

    it "应该还没提交" do
      @practice.in_submitted_status_of_user?(@user).should == false
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

        Timecop.travel(@time) do
          @practice.submit_by_user(@user)
        end
      }


      it "已经提交" do
        @practice.in_submitted_status_of_user?(@user).should == true
      end

      it "还没被批阅" do
        @practice.in_checked_status_of_user?(@user).should == false
      end

      it "提交时间正确" do
        @practice.submitted_time_by_user(@user).to_i.should == @time.to_i
      end

      it "批阅时间为空" do
        @practice.checked_time_by_user(@user).blank?.should == true
      end


      describe '批阅习题' do
        before {
          @time = Time.now

          Timecop.travel(@time) do
            @practice.check_by_user(@user)
          end
          
        }

        it "已经被批阅" do
          @practice.in_checked_status_of_user?(@user).should == true
        end

        it "批阅时间正确" do
          @practice.checked_time_by_user(@user).to_i.should == @time.to_i
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

    }

    it "practice 创建成功" do
      @practice.id.blank?.should == false
    end

    it "习题附件数量正确" do 
      @practice.requirements.count.should == 2    
    end

    describe "习题提交物" do
      before {
       
        @requirement = @practice.requirements.first

        @file_entity_1 = FactoryGirl.create(:file_entity)
        @file_entity_2 = FactoryGirl.create(:file_entity)

        @upload_params_1 = {:file_entity => @file_entity_1, :name => '提交物1', :creator => @user}
        @upload_params_2 = {:file_entity => @file_entity_2, :name => '提交物2', :creator => @user}

        @requirement.uploads.create(@upload_params_1)
        @requirement.uploads.create(@upload_params_2)
      }


      it "数量正确" do
        @requirement.uploads.count.should == 2
      end
    end

    

  end

  
end