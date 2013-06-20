course_wares = CourseWare.where(:title=>"视频",:kind => ['tudou','youku'])

count = course_wares.count

course_wares.each_with_index do |course_ware, index|
  p "#{index+1}/#{count}"
  begin
    course_ware.record_timestamps = false

      title = course_ware.get_video_title
      course_ware.title = title
      course_ware.save!
    
    course_ware.record_timestamps = true

  rescue
    p "course_ware #{course_ware.id} 获取标题失败"
  end

end


course_wares = CourseWare.where(:title=>"视频",:kind => ['tudou','youku'])
if course_wares.blank?
  p "全部成功"
else
  p "获取标题失败的 course_ware ids 如下"
  p course_wares.map{|c|c.id}
end