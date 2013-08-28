

teachers = User.with_role :teachers
students = User.with_role :students


course_names = %w{NOI信息学竞赛训练 科学发明创新 物理实验 物理竞赛训练 趣味化学}
course_teachers = teachers[0..4]
# 创建五个课程
courses = []
course_names.each_with_index do |name,index|
  course = Course.create!(:name => name, :cid => randstr, :creator => course_teachers[index])
  courses << course
end

team_1_teacher = teachers[5]
team_2_teacher = teachers[6]
team_1_students = students[0..9]
team_2_students = students[10..19]
# 创建两个班级
team_1 = Team.create!(:name => '一班', :teacher_user => team_1_teacher)
team_1_students.each do |user|
  team_1.add_member(user)
end

team_2 = Team.create!(:name => '二班', :teacher_user => team_2_teacher)
team_2_students.each do |user|
  team_2.add_member(user)
end

has_intent_users = team_1_students[0..4] + team_2_students[5..9]
# 10 个 随机选择随机选择志愿
has_intent_users.each do |user|
  first_index = rand(5)
  second_index = (first_index+1)%5
  third_index = (first_index+2)%5

  user.set_select_course_intent(:first, courses[first_index])
  user.set_select_course_intent(:second, courses[second_index])
  user.set_select_course_intent(:third, courses[third_index])
end