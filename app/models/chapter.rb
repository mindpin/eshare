class Chapter < ActiveRecord::Base
  include MovePosition::ModelMethods
  include CourseReadPercent::ChapterMethods
  include Note::ChapterMethods

  attr_accessible :title, :desc, :creator, :course

  belongs_to :course
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"

  validates :title, :presence => true
  validates :course,  :presence => true
  validates :creator, :presence => true

  has_many :course_wares
  has_many :questions
  has_many :practices

  scope :by_course, lambda{|course| {:conditions => ['course_id = ?', course.id]} }

  def prev
    self.class.by_course(course).where('position < ?', self.position).last
  end

  def next
    self.class.by_course(course).where('position > ?', self.position).first
  end

  def course_wares_read_stat_of(user)
    scope = self.course_wares.joins(%~
      LEFT OUTER JOIN course_ware_readings
      ON course_ware_readings.user_id = #{user.id}
      AND course_ware_readings.course_ware_id = course_wares.id
    ~)

    none = scope.where('course_ware_readings.read_count = ? OR course_ware_readings.read_count IS NULL', 0).count
    read = scope.where('course_ware_readings.read_count = course_wares.total_count').count
    reading = self.course_wares.count - none - read

    return {
      :none => none,
      :read => read,
      :reading => reading
    }
  end

  def import_course_ware_form_json(json_data, user)
    CourseWare.transaction do
      course_ware = course_wares.create(
        {
          :creator => user,
          :title => json_data[:title],
          :desc => json_data[:desc],
          :kind => json_data[:kind]
        }, { :as => :import }
      )

      json_data[:steps].each do |s|
        course_ware.javascript_steps.create(
          :content => s[:content],
          :rule => s[:rule],
          :title => s[:title],
          :desc => s[:desc],
          :hint => s[:hint],
          :init_code => s[:init_code]
        )
      end

      course_ware.refresh_total_count!

      course_ware
    end
    
  end

end
