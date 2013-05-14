# -*- coding: utf-8 -*-
require './script/makers/user_maker'

defpack 1 do
  User.destroy_all
  admin = User.create(:login    => 'admin',
                      :name     => '管理员',
                      :email    => 'admin@edu.dev',
                      :password => '1234',
                      :role     => :admin)
  ['teachers', 'students'].each {|yaml| UserMaker.new(yaml).produce}
end
