require 'spec_helper'

describe Homework do
  describe '创建没有要求的作业' do
    it{
      user = FactoryGirl.create(:user)
      chapter = FactoryGirl.create(:chapter)

      homework = chapter.homeworks.new(
        :title => '标题', :content => "内容", 
        :deadline => Time.now + 10.day)

      homework.creator = user

      expect{
          homework.save
      }.to change{Homework.count}.by(1)
    }
  end

  describe '创建有要求的作业' do
    before(:all) do
      user = FactoryGirl.create(:user)
      chapter = FactoryGirl.create(:chapter)

      homework_requirements_attributes = [
        {:content => "要求一"},
        {:content => "要求二"}
      ]

      @homework = chapter.homeworks.new(
        :title => '标题', :content => "内容", 
        :deadline => Time.now + 10.day,
        :homework_requirements_attributes => homework_requirements_attributes
        )

      @homework.creator = user

      expect{
          @homework.save
      }.to change{Homework.count}.by(1)
    end

    it{
      @homework.homework_requirements.count.should == 2
    }

    it{
      @homework.homework_requirements.first.homework.should == @homework
      @homework.homework_requirements.first.content.should == '要求一'
    }

    it{
      @homework.homework_requirements.last.homework.should == @homework
      @homework.homework_requirements.last.content.should == '要求二'
    }
  end

  describe '创建有附件的作业' do
    before(:all) do
      user = FactoryGirl.create(:user)
      chapter = FactoryGirl.create(:chapter)
      @file_entity_1 = FactoryGirl.create(:file_entity)
      @file_entity_2 = FactoryGirl.create(:file_entity)
      
      homework_attaches_attributes = [
        {:file_entity_id => @file_entity_1.id, :name => '附件一'},
        {:file_entity_id => @file_entity_2.id, :name => '附件二'}
      ]

      @homework = chapter.homeworks.new(
        :title => '标题', :content => "内容", 
        :deadline => Time.now + 10.day,
        :homework_attaches_attributes => homework_attaches_attributes
        )

      @homework.creator = user

      expect{
          @homework.save
      }.to change{Homework.count}.by(1)
    end

    it{
      @homework.homework_attaches.count.should == 2
    }

    it{
      @homework.homework_attaches.first.file_entity.should == @file_entity_1
      @homework.homework_attaches.first.name.should == '附件一'
      @homework.homework_attaches.first.homework.should == @homework
    }


    it{
      @homework.homework_attaches.last.file_entity.should == @file_entity_2
      @homework.homework_attaches.last.name.should == '附件二'
      @homework.homework_attaches.last.homework.should == @homework
    }
  end
  
end
