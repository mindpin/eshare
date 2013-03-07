require './script/makers/user_maker'

defpack 1 do
  [User, Teacher, Student].each(&:destroy_all)

  admin = User.create(:login    => 'admin',
                      :name     => '管理员',
                      :email    => 'admin@edu.dev',
                      :password => '1234')

  admin.set_role :admin
  
  ['teachers', 'students'].each {|yaml| UserMaker.load_yaml(yaml).produce}
end
