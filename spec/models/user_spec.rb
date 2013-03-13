require "spec_helper"

describe User do

  describe "import file" do
    context "import teacher excel files" do
      it "import xls format" do
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'teacher.xls',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/teacher.xls'))
        })

        User.count.should == 0
        User.import(file, :teacher)
        User.count.should == 3

        teacher2 = User.find_by_email('hi22@gmail.com')
        teacher2.login.should == 'bbb22'
        teacher2.email.should == 'hi22@gmail.com'
        teacher2.role?(:teacher).should == true
      end

      it "import xlsx format" do
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => 'msexcel_teacher.xlsx',
          :type => 'application/vnd.ms-excel',
          :tempfile => File.new(Rails.root.join('spec/data/msexcel_teacher.xlsx'))
        })
       
        User.count.should == 0
        User.import(file, :teacher)
        User.count.should == 3

        teacher_xlsx = User.find_by_email('www22@gmail.com')
        teacher_xlsx.login.should == 'www22'
        teacher_xlsx.email.should == 'www22@gmail.com'
        teacher_xlsx.role?(:teacher).should == true
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

        teacher_xlsx = User.find_by_email('ooo22@gmail.com')
        teacher_xlsx.login.should == 'ooo22'
        teacher_xlsx.email.should == 'ooo22@gmail.com'
        teacher_xlsx.role?(:teacher).should == true
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

        student2 = User.find_by_email('hi2@gmail.com')
        student2.login.should == 'bbb2'
        student2.email.should == 'hi2@gmail.com'
        student2.role?(:student).should == true
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

        teacher_xlsx = User.find_by_email('www2@gmail.com')
        teacher_xlsx.login.should == 'www2'
        teacher_xlsx.email.should == 'www2@gmail.com'
        teacher_xlsx.role?(:student).should == true
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

        teacher_xlsx = User.find_by_email('ooo2@gmail.com')
        teacher_xlsx.login.should == 'ooo2'
        teacher_xlsx.email.should == 'ooo2@gmail.com'
        teacher_xlsx.role?(:student).should == true
      end
    end
  end

end



=begin
  it "import excel file" do
    # 测试 xls 格式老师导入
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


    # 测试 xlsx 格式老师导入
    file = ActionDispatch::Http::UploadedFile.new({
      :filename => 'msexcel_teacher.xlsx',
      :type => 'application/vnd.ms-excel',
      :tempfile => File.new(Rails.root.join('spec/data/msexcel_teacher.xlsx'))
    })
   
    User.count.should == 3
    User.import(file, :teacher)

    teacher_xlsx = User.find_by_email('www22@gmail.com')
    teacher_xlsx.login.should == 'www22'
    teacher_xlsx.email.should == 'www22@gmail.com'
    teacher_xlsx.role?(:teacher).should == true


    # 测试 openoffice 格式老师导入
    file = ActionDispatch::Http::UploadedFile.new({
      :filename => 'openoffice_teacher.sxc',
      :type => 'application/vnd.ms-excel',
      :tempfile => File.new(Rails.root.join('spec/data/openoffice_teacher.sxc'))
    })
   
    User.count.should == 6
    User.import(file, :teacher)

    teacher_xlsx = User.find_by_email('ooo22@gmail.com')
    teacher_xlsx.login.should == 'ooo22'
    teacher_xlsx.email.should == 'ooo22@gmail.com'
    teacher_xlsx.role?(:teacher).should == true


    # 测试 xls 格式学生导入
    file = ActionDispatch::Http::UploadedFile.new({
      :filename => 'teacher.xls',
      :type => 'application/vnd.ms-excel',
      :tempfile => File.new(Rails.root.join('spec/data/student.xls'))
    })
   
    User.count.should == 9
    User.import(file, :student)

    student2 = User.find_by_email('hi2@gmail.com')
    student2.login.should == 'bbb2'
    student2.email.should == 'hi2@gmail.com'
    student2.role?(:student).should == true


    # 测试 xlsx 格式学生导入
    file = ActionDispatch::Http::UploadedFile.new({
      :filename => 'msexcel_student.xlsx',
      :type => 'application/vnd.ms-excel',
      :tempfile => File.new(Rails.root.join('spec/data/msexcel_student.xlsx'))
    })
   
    User.count.should == 12
    User.import(file, :student)

    teacher_xlsx = User.find_by_email('www2@gmail.com')
    teacher_xlsx.login.should == 'www2'
    teacher_xlsx.email.should == 'www2@gmail.com'
    teacher_xlsx.role?(:student).should == true



    # 测试 openoffice 格式学生导入
    file = ActionDispatch::Http::UploadedFile.new({
      :filename => 'openoffice_student.sxc',
      :type => 'application/vnd.ms-excel',
      :tempfile => File.new(Rails.root.join('spec/data/openoffice_student.sxc'))
    })
   
    User.count.should == 15
    User.import(file, :student)

    teacher_xlsx = User.find_by_email('ooo2@gmail.com')
    teacher_xlsx.login.should == 'ooo2'
    teacher_xlsx.email.should == 'ooo2@gmail.com'
    teacher_xlsx.role?(:student).should == true
=end