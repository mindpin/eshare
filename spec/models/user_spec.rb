require "spec_helper"

describe User do

  describe "import file" do
    it "should raise format error" do
      file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'incorrect_excel.aaa',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/incorrect_excel.aaa'))
        })

        expect {
          User.import(file, :teacher)
        }.to raise_error(User::FormatError)
    end


    context "import teacher excel files" do
      describe "import xls format" do
        before(:each){
          file = ActionDispatch::Http::UploadedFile.new({
            :filename => 'teacher.xls',
            :type => 'application/vnd.ms-excel',
            :tempfile => File.new(Rails.root.join('spec/data/teacher.xls'))
          })
          User.count.should == 0
          User.import(file, :teacher)
          User.count.should == 3

          @user = User.find_by_email('hi22@gmail.com')
        }

        it{
          @user.login.should == 'bbb22'
        }

        it{
          @user.email.should == 'hi22@gmail.com'
        }

        it{
          @user.role?(:teacher).should == true
        }
      end



      describe "import xlsx format" do
        before(:each){
          file = ActionDispatch::Http::UploadedFile.new({
            :filename => 'msexcel_teacher.xlsx',
            :type => 'application/vnd.ms-excel',
            :tempfile => File.new(Rails.root.join('spec/data/msexcel_teacher.xlsx'))
          })
          User.count.should == 0
          User.import(file, :teacher)
          User.count.should == 3

          @user = User.find_by_email('www22@gmail.com')
        }

        it{
          @user.login.should == 'www22'
        }

        it{
          @user.email.should == 'www22@gmail.com'
        }

        it{
          @user.role?(:teacher).should == true
        }
      end



      it "import openoffice format" do
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'openoffice_teacher.sxc',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/openoffice_teacher.sxc'))
        })
       
        User.count.should == 0
        User.import(file, :teacher)
        User.count.should == 3

        teacher = User.find_by_email('ooo22@gmail.com')
        teacher.login.should == 'ooo22'
        teacher.email.should == 'ooo22@gmail.com'
        teacher.role?(:teacher).should == true
      end
    end


    context "import student excel files" do
      it "import xls format" do
        
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'teacher.xls',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/student.xls'))
        })
       
        User.count.should == 0
        User.import(file, :student)
        User.count.should == 3

        student = User.find_by_email('hi2@gmail.com')
        student.login.should == 'bbb2'
        student.email.should == 'hi2@gmail.com'
        student.role?(:student).should == true
        
      end



      it "import xlsx format" do
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'msexcel_student.xlsx',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/msexcel_student.xlsx'))
        })
       
        User.count.should == 0
        User.import(file, :student)
        User.count.should == 3

        student = User.find_by_email('www2@gmail.com')
        student.login.should == 'www2'
        student.email.should == 'www2@gmail.com'
        student.role?(:student).should == true
      end

      it "import openoffice format" do
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'openoffice_student.sxc',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/openoffice_student.sxc'))
        })
       
        User.count.should == 0
        User.import(file, :student)
        User.count.should == 3

        student = User.find_by_email('ooo2@gmail.com')
        student.login.should == 'ooo2'
        student.email.should == 'ooo2@gmail.com'
        student.role?(:student).should == true
      end
    end

    
  end

end
