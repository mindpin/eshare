require "spec_helper"

describe Course do

  describe "import file" do
    before(:each){
      @user = FactoryGirl.create :user
    }
    
    it "should raise format error" do
      file = File.new 'spec/data/course_import_test_files/incorrect_excel.aaa'

      expect {
        Course.import(file, @user)
      }.to raise_error(Exception)
    end


    context "import course excel files" do
      describe "import xls format" do
        before(:each){
          @file = File.new 'spec/data/course_import_test_files/courses.xls'
        }

        it {
          expect{
            Course.import(@file, @user)
          }.to change{Course.count}.by(3)
        }

        it {
          Course.import(@file, @user)
          Course.all.each do |course|
            if course.cid == '111'
              course.name.should === '数学1'
            end
          end
        }
      end

      describe "import xlsx format" do
        before(:each){
          @file = File.new 'spec/data/course_import_test_files/courses.xlsx'
        }

        it {
          expect {
            Course.import(@file, @user)
          }.to change{Course.count}.by(3)
        }

        it {
          Course.import(@file, @user)
          Course.all.each do |course|
            if course.cid == '222'
              course.name.should === '数学2'
            end
          end
        }
      end

      describe "import openoffice format" do
        before {
          @file = File.new 'spec/data/course_import_test_files/courses.sxc'
        }

        it {
          expect {
            Course.import(@file, @user)
          }.to change{Course.count}.by(3)
        }

        it {
          Course.import(@file, @user)
          Course.all.each do |course|
            if course.cid == '333'
              course.name.should === '数学3'
            end
          end
        }
      end

    end
  end
end
