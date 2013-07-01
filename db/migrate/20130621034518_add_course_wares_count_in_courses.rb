class AddCourseWaresCountInCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_wares_count, :integer, :default => 0

    _set_value_for_old_data
  end

  def _set_value_for_old_data

    courses = Course.all
    count = courses.count
    courses.each_with_index do |course, index|
      p "#{index+1}/#{count}, id #{course.id}"

      course_wares = CourseWare.unscoped.joins(:chapter).where("chapters.course_id = #{course.id}").order("course_wares.updated_at desc")

      course.record_timestamps = false

      if !course_wares.blank?
        course.updated_at = course_wares.first.updated_at        
      end
      course.course_wares_count = course.course_wares.count
      course.save(:validate => false)

      course.record_timestamps = true

    end
  end
end
