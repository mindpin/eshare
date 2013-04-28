class CourseWareReadingDelta < ActiveRecord::Base
  attr_accessible :user, :course_ware, :date, :change, :value

  belongs_to :user
  belongs_to :course_ware

  validates :user, :course_ware, :date, :presence => true

  scope :by_date, lambda { |date| 
    di = date.strftime("%Y%m%d").to_i
    {
      :conditions => {:date => di}
    }
  }

  scope :of_user, lambda { |user|
    { :conditions => ['user_id = ?', user.id]}
  }

  scope :of_course_ware, lambda { |course_ware|
    { :conditions => ['course_ware_id = ?', course_ware.id] }
  }

  def self.get_record_of(course_ware, user, date)
    di = date.strftime("%Y%m%d").to_i

    CourseWareReadingDelta.of_course_ware(course_ware).of_user(user).by_date(date).first ||
    CourseWareReadingDelta.new({
      :course_ware => course_ware,
      :user => user,
      :date => di,
      :change => 0,
      :value => course_ware.read_count_value_of(user, date)
    })
  end

  module CourseWareMethods
    extend ActiveSupport::Concern

    included do
      has_many :course_ware_reading_deltas
    end

    def read_count_change_of(user, date)
      CourseWareReadingDelta.get_record_of(self, user, date).change
    end

    # 获取指定日期的 read_count 值
    # 先查是否有小于等于指定日期的 delta 记录，如果有，直接返回 delta.value
    # 如果没有，就查找 reading 记录，看 reading 记录的 created_at 日期，是否早于指定的日期
    # 是 返回 reading.read_count
    # 否 返回 0
    def read_count_value_of(user, date)
      # 获取指定

      last_delta = CourseWareReadingDelta
        .of_course_ware(self)
        .of_user(user)
        .where('date <= ?', date.strftime("%Y%m%d").to_i)
        .order('date DESC')
        .first

      return last_delta.blank? ? 0 : last_delta.value
    end

    def last_week_read_count_changes_of(user)
      today = Date.today
      re = []

      6.downto 0 do |x|
        date = today - x
        re << {
          :date => date,
          :change => read_count_change_of(user, date),
          :value => read_count_value_of(user, date),
        }
      end

      return re
    end
  end

  module CourseWareReadingMethods
    extend ActiveSupport::Concern

    included do
      before_save :record_read_count_delta
    end

    def record_read_count_delta
      change = _get_read_count_change
      return true if change == 0

      delta = CourseWareReadingDelta.get_record_of(course_ware, user, Date.today)
      delta.change = delta.change + change
      delta.value = read_count
      delta.save

      return true
    end

    private
      def _get_read_count_change
        return read_count || 0 if new_record?

        if read_count_changed?
          before = read_count_change[0] || 0
          after  = read_count_change[1] || 0

          return after - before
        end

        return 0
      end
  end
end