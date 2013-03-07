require './script/helper'
require './script/pack1'

case ARGV[0]
when 'clear-pack-records'
  puts '删除脚本运行记录....'
  `rm -rf tmp/scripts`
  exit
when 'clear-db'
  puts '清空数据库....'
  `rake db:drop && rake db:create && rake db:migrate > /dev/null`
  exit
end

prompt = '
==============================================

            请选择要导入的数据包

==============================================

1. 学生、教师、管理员等用户相关

==============================================

'

puts prompt

def get_choice
  puts '请选择要导入的选项(1-1):'
  choice = gets.chomp.to_i

  return choice if (1..1) === choice
  get_choice
end

def run
  `mkdir -p tmp/scripts`
  choice = get_choice
  puts "准备运行选项-#{choice}......\n\n"
  send "pack#{choice}"
end

run
