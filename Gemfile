source 'http://ruby.taobao.org'

gem 'rails', '3.2.12' # RAILS
gem 'mysql2', '0.3.11' # MYSQL数据库连接
gem 'json', '1.7.7' # JSON解析，RAILS默认引入的

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3', '0.3.2' # 加速预编译
end

group :test do
  gem 'rspec-rails', '2.13.0'
  gem 'database_cleaner', '0.9.1' # 加速测试时数据库清理
  gem 'factory_girl_rails', '~> 4.2.1'
end

group :examples do
  gem 'ruby-progressbar', '~> 1.0.2'
end

gem 'jquery-rails', '2.2.1'
gem 'unicorn', '4.6.2'

#### 登录验证
gem 'devise', '2.2.3'

#### 页面渲染
gem 'haml', '4.0.0' # HAML模板语言
gem 'cells', '3.8.8' # 用于复用一些前端组件
gem 'simple_form', '2.0.2' # 用于简化表单创建

#### 数据查询
gem 'pacecar', '1.5.3' # 给模型添加实用的scope
gem 'will_paginate', '3.0.4' # 分页支持

#### 角色
gem 'roles-field', '0.0.2', :git => 'git://github.com/mindpin/roles-field.git'

#### 其他 gem
# 文件上传（fushang318增加） 
gem "carrierwave", "0.8.0"
# carrierwave 用到的图片切割
gem "mini_magick", "3.5.0", :require => false
gem 'simple-navbar', :git => 'git://github.com/mindpin/simple-navbar.git'
