

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

# 10 个 随机选择随机选择志愿
has_intent_users.each do |user|
  first_index = rand(5)
  second_index = (first_index+1)%5
  third_index = (first_index+2)%5

  user.set_select_course_intent(:first, courses[first_index])
  user.set_select_course_intent(:second, courses[second_index])
  user.set_select_course_intent(:third, courses[third_index])
end