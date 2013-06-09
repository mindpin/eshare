ActiveRecord::Base.transaction do
p "导入 admin 用户"
User.create!(:login => 'admin', 
            :name => '管理员', 
            :email => 'admin@edu.dev', 
            :password => '1234', 
            :role => :admin)
p "导入 admin 用户完成"

p "导入测试用户"
Dir["/download/user_avatar/*.jpg"].each_with_index do |avatar_path, index|
  p "user #{index+1}/19"
  name = File.basename(avatar_path,'.jpg')
  User.create!(:login => "mindpin#{index+1}", 
              :name => name, 
              :email => "mindpin#{index+1}@edu.dev", 
              :password => '1234',
              :avatar => File.new(avatar_path),
              :role => :teacher)
end
p "导入测试用户完成"


p "导入网盘公共分类"
require './script/makers/category_maker'
CategoryMaker.new.produce
p "导入网盘公共分类完成"

p "导入课程"
yaml = Rails.root.join('script/data/video_courses.yaml')
if !File.exists?(yaml)
  `wget https://gist.github.com/kaid/589f60e53dbb735878e8/raw/0d2b5fcd025c5d412759c05d35f1afa7b9d21fe1/video_courses.yaml -O #{yaml} --no-check-certificate`
end
Course.import_from_yaml_for_web
p "导入课程完成"
end