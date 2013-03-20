require "spec_helper"

describe Course do

  describe "import file" do
    before(:each){
      @user = User.create(:name => 'test', 
        :login => 'test', 
        :email => 'test@g.com', 
        :password => 'test', 
        :role => :student)
    }
    
    it "should raise format error" do

      file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'incorrect_excel.aaa',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/incorrect_excel.aaa'))
        })

        expect {
          Course.import(file, @user)
        }.to raise_error(ImportFile::FormatError)
    end


    context "import course excel files" do
      describe "import xls format" do
        before(:each){
          file = ActionDispatch::Http::UploadedFile.new({
            :filename => 'courses.xls',
            :type => 'application/vnd.ms-excel',
            :tempfile => File.new(Rails.root.join('spec/data/courses.xls'))
          })

          expect{
            Course.import(file, @user)
          }.to change{Course.count}.by(3)

        }

        it{
          Course.all.each do |course|
            if course.cid == '111'
              course.name.should === '数学1'
            end
          end
        }
      end
    


      describe "import xlsx format" do
        before(:each){
          file = ActionDispatch::Http::UploadedFile.new({
            :filename => 'courses.xlsx',
            :type => 'application/vnd.ms-excel',
            :tempfile => File.new(Rails.root.join('spec/data/courses.xlsx'))
          })

          expect{
            Course.import(file, @user)
          }.to change{Course.count}.by(3)
        }

        it{
          Course.all.each do |course|
            if course.cid == '222'
              course.name.should === '数学2'
            end
          end
        }
      end



      describe "import openoffice format" do
        before(:each){
          file = ActionDispatch::Http::UploadedFile.new({
            :filename => 'courses.sxc',
            :type => 'application/vnd.ms-excel',
            :tempfile => File.new(Rails.root.join('spec/data/courses.sxc'))
          })
         
          expect{
            Course.import(file, @user)
          }.to change{Course.count}.by(3)
        }

        it{
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
