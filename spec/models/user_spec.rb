require "spec_helper"

describe User do
  it "import excel file" do
    # 测试老师导入
    file = ActionDispatch::Http::UploadedFile.new({
      :filename => 'teacher.xls',
      :type => 'application/vnd.ms-excel',
      :tempfile => File.new(Rails.root.join('spec/data/teacher.xls'))
    })
   
    User.count.should == 0
    User.import(file, :teacher)

    teacher2 = User.find_by_email('hi22@gmail.com')
    teacher2.login.should == 'bbb22'
    teacher2.email.should == 'hi22@gmail.com'
    teacher2.role?(:teacher).should == true


    # 测试学生导入
    file = ActionDispatch::Http::UploadedFile.new({
      :filename => 'teacher.xls',
      :type => 'application/vnd.ms-excel',
      :tempfile => File.new(Rails.root.join('spec/data/student.xls'))
    })
   
    User.count.should == 3
    User.import(file, :student)
    User.count.should == 6

    student2 = User.find_by_email('hi2@gmail.com')
    student2.login.should == 'bbb2'
    student2.email.should == 'hi2@gmail.com'
    student2.role?(:student).should == true
  end
end