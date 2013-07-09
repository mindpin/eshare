# -*- coding: utf-8 -*-
source 'http://ruby.taobao.org'

gem 'rails', '3.2.12' # RAILS #不要更新 3.2.13 有性能问题，等 3.2.14
gem 'mysql2', '0.3.11' # MYSQL数据库连接
gem 'json', '1.7.7' # JSON解析，RAILS默认引入的
gem 'rubyzip', '0.9.9', :require => false
gem 'docsplit', '0.7.2'
gem 'sunspot_rails', '2.0.0'
gem 'chinese_pinyin', '0.4.2'
gem 'rmmseg-cpp-huacnlee', '0.2.9'
gem 'redis-search', :git => 'git://github.com/huacnlee/redis-search.git'

group :internet do
  gem 'sqlite3', "~> 1.3.7"
end

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3', '0.3.2' # 加速预编译
end

group :test do
  gem "awesome_print"
  gem 'rspec-rails', '2.13.0'
  gem 'database_cleaner', '0.9.1' # 加速测试时数据库清理
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'coveralls', :require => false # 帮助在 coveralls.io 线统计测试覆盖率
  gem 'capybara', '2.0.2' # 集成测试框架
  gem 'timecop', '0.6.1' # 用于在测试中调整时间
  gem 'rspec-cells', '0.1.7' # 用于测试 cells
  gem 'sunspot-rails-tester', '1.0.0'
end

group :examples do
  gem 'ruby-progressbar', '~> 1.0.2'
end

group :development do
  gem 'thin', '~> 1.5.1'
end

gem 'jquery-rails', '2.2.1'
gem 'jquery-ui-rails', '4.0.2'
gem 'unicorn', '4.6.2'
gem 'sidekiq', '2.8.0'
gem 'sidekiq-limit_fetch', '1.4'
gem 'faye-rails', '~> 1.0.8'
gem 'slim', '1.3.8', :require => false
gem 'sinatra', '1.3.0', :require => false

# 登录验证
gem 'devise', '2.2.4'

# 页面渲染
gem 'haml', '4.0.0' # HAML模板语言
gem 'cells', '3.8.8' # 用于复用一些前端组件
gem 'simple_form', '2.0.2' # 用于简化表单创建

# 数据查询
gem 'pacecar', '1.5.3' # 给模型添加实用的scope
gem 'kaminari', '0.14.1' # 分页支持

# 文件上传（fushang318增加） 
gem "carrierwave", "0.8.0"
# carrierwave 用到的图片切割
gem "mini_magick", "3.5.0", :require => false

# # 解析 excel 文件
# gem 'roo', '1.10.3'

# 编码处理基础库
gem 'iconv', '1.0.2'


# 分类目录
gem 'awesome_nested_set'

# 权限管理
gem "cancan", "~> 1.6.10"

# weibo oauth2
gem "omniauth-github", "~> 1.1.0"
gem 'omniauth-weibo-oauth2'
gem "weibo_2", "~> 0.1.1"
gem 'rmmseg-cpp'

# 自己写的 gem，都不指定版本号，如果有重大修改，通过GIT TAG解决

## 用户角色
gem 'roles-field',
    :git => 'git://github.com/mindpin/roles-field.git'
    # :path => '/web/songliang/roles-field'

## 导航栏
gem 'simple-navbar',
    :git => 'git://github.com/mindpin/simple-navbar.git',
    :tag => '0.0.1'

## 页面布局辅助
gem 'simple-page-layout',
    :git => 'git://github.com/mindpin/simple-page-layout',
    :tag => '0.0.3'
    # :path => '/web/songliang/simple-page-layout'

## 在页面上显示图片的一些辅助方法
gem 'simple-images',
    :git => 'git://github.com/mindpin/simple-images',
    :tag => '0.0.3'
    # :path => '/web/songliang/simple-images'

gem 'simple-page-compoents',
    :git => 'git://github.com/mindpin/simple-page-compoents',
    :tag => '0.0.7.5'
    # :path => '/web/songliang/simple-page-compoents'

## 给指定 activerecord 模型动态添加属性
gem 'dynamic_attrs',
    :git => 'git://github.com/kaid/dynamic_attrs.git'

## 文件分段上传
gem 'file-part-upload', 
    :git => 'git://github.com/mindpin/file-part-upload.git',
    :tag => '0.0.8'

## excel导入和示例生成
gem 'simple-excel-import',
    :git => 'git://github.com/mindpin/simple-excel-import.git',
    :tag => '0.0.2.7'
    # :path => '/web/songliang/simple-excel-import'
    # gem 'axlsx', '1.3.5' # 上面的gem依赖它

## tag
gem 'mindpin-simple-tags',
    :git => 'git://github.com/mindpin/mindpin-simple-tags.git',
    :tag => '0.0.4'

# feed
gem 'mindpin-feeds',
    :git => 'git://github.com/mindpin/mindpin-feeds',
    :tag => '0.1.3'

# redis-cache
gem 'simple-redis-cache',
    :git => 'git://github.com/mindpin/simple-redis-cache.git',
    :tag => '0.0.2'

gem 'simple_comment',
    :git => 'git://github.com/kaid/simple_comment.git'

gem 'mina',
    :git => 'git://github.com/fushang318/mina.git',
    :tag => 'v0.2.0fix'

gem 'simple-survey',
    :git => 'git://github.com/mindpin/simple-survey.git',
    :tag => '0.0.8'
