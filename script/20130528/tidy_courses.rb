Course.all.each do |course|
  begin
    if course.chapters.count > 0 && course.chapters.count == course.course_wares.count
      old_chapters = course.chapters.to_a

      # 创建默认章节
      chapter = course.chapters.create  :title   => "默认章节",
                                        :creator => course.creator

      # 调整模型关联
      course.course_wares.each do |cw|
        cw.chapter = chapter
        cw.save

        cw.course_ware_readings.each do |cwr|
          cwr.chapter = chapter
          cwr.save
        end

        cw.questions.each do |q|
          q.chapter = chapter
          q.save
        end
      end

      # 删除其他章节
      old_chapters.each do |oc|
        oc.destroy
      end

      p "Course #{course.id} completed."
    end
  rescue Exception => ex
    p ex
  end
end