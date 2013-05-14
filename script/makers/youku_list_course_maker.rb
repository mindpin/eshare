require './script/makers/base_maker.rb'

class YoukuListCourseMaker < BaseMaker
  set_producer {|item, _|
    user = User.first
    course = Course.import_youku_video_list(item['url'], user)
    course.replace_public_tags(item['tags'], user)
  }
end
