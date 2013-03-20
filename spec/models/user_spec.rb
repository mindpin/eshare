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
        }.to raise_error(ImportFile::FormatError)
    end


    context "import teacher excel files" do
      describe "import xls format" do
        before(:each){
          file = ActionDispatch::Http::UploadedFile.new({
            :filename => 'user.xls',
            :type => 'application/vnd.ms-excel',
            :tempfile => File.new(Rails.root.join('spec/data/user.xls'))
          })

          expect{
            User.import(file, :teacher)
          }.to change{User.count}.by(3)

          @user = User.find_by_email('hi2@gmail.com')
        }

        it{
          @user.login.should == 'aaa2'
        }

        it{
          @user.role?(:teacher).should == true
        }
      end



      describe "import xlsx format" do
        before(:each){
          file = ActionDispatch::Http::UploadedFile.new({
            :filename => 'user.xlsx',
            :type => 'application/vnd.ms-excel',
            :tempfile => File.new(Rails.root.join('spec/data/user.xlsx'))
          })

          expect{
            User.import(file, :teacher)
          }.to change{User.count}.by(3)

          @user = User.find_by_email('hi2@gmail.com')
        }

        it{
          @user.login.should == 'aaa2'
        }

        it{
          @user.role?(:teacher).should == true
        }
      end



      it "import openoffice format" do
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'user.sxc',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/user.sxc'))
        })
       
        expect{
          User.import(file, :teacher)
        }.to change{User.count}.by(3)
      end
    end


    context "import student excel files" do
      it "import xls format" do
        
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'user.xls',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/user.xls'))
        })
       
        expect{
          User.import(file, :student)
        }.to change{User.count}.by(3)

      end



      it "import xlsx format" do
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'user.xlsx',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/user.xlsx'))
        })

        expect{
          User.import(file, :student)
        }.to change{User.count}.by(3)
      end

      it "import openoffice format" do
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'user.sxc',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/user.sxc'))
        })
       
        expect{
          User.import(file, :student)
        }.to change{User.count}.by(3)
      end
    end

    
  end

end
