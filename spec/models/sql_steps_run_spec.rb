require 'spec_helper'

describe SqlStep do
  before {
    @user = FactoryGirl.create(:user)
    @sql_step = FactoryGirl.create(:sql_step)

    @sql_step.run("create table articles (title varchar(200));", @user)

  }

  after {
    # FileUtils.rm_rf @db_file_path
  }


  describe "正常SQL" do

    describe "查询语句" do
      before {
        @input = 'select * from articles'
        @query = @sql_step.run(@input, @user)
      }

      it "表记录为空" do
        @query.result.should == []
      end

      it "exception 为空" do
        @query.exception.should == ''
      end

      it "input 正常" do
        @query.input.should == @input
      end

    end

    describe "插入语句" do
      before {
        @input = 'insert into numbers values ("title 1")'
        @query = @sql_step.run(@input, @user)
      }

      it "1条表记录" do
        @query.result.count.should == 1
      end
    end

    describe "删除语句" do
    end

  end

  describe "错误SQL" do
  end
end