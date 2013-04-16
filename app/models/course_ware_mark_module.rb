module CourseWareMarkModule
  
  # 2 封装增加标记的方法 course.add_mark(user,position,content)
  def add_mark(user,position,content)
    return if content.blank? || position.blank? || user.blank?
    self.course_ware_marks.create :user     => user,
                                  :position => position,
                                  :content  => content
  end

  # 3 封装获取标记的方法
  def get_marks(position)
    self.course_ware_marks.by_position(position)
  end
end