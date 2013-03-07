# -*- coding: utf-8 -*-
$students = YAML.load_file 'script/data/students.yaml'
$teacher  = YAML.load_file 'script/data/teachers.yaml'

defpack 1 do
  semester = Semester.now

  admin = User.create(:name => 'admin',
                      :email => 'admin@edu.dev',
                      :password => '1234')

  admin.set_role :admin

  puts ">>>>>>>> 管理员"

  $students.reduce(1) do |count, name|
    user = User.create(:name => "student#{count}",
                       :email => "student#{count}@edu.dev",
                       :password => '1234')

    user.set_role :student

    student = Student.create(:real_name => name,
                             :sid => "sid-#{count}",
                             :user => user)

    puts ">>>>>>>> 学生: #{student.real_name}; sid: #{student.sid}"

    count + 1
  end

  $teachers.reduce(1) do |count, name|
    user = User.create(:name => "teacher#{count}",
                       :email => "teacher#{count}@edu.dev",
                       :password => '1234')

    user.set_role :teacher

    teacher = Teacher.create(:real_name => name,
                             :tid => "tid-#{count}",
                             :user => user)

    puts ">>>>>>>> 老师: #{teacher.real_name}; tid: #{teacher.tid}"

    count + 1
  end

end
