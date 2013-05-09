class CourseWareReadingDelta < ActiveRecord::Base
  attr_accessible :user, :course_ware, 
                  :date, :weekday, :year, :month, :day,
                  :change, :value, 
                  :percent_change, :percent_value,
                  :total_count

  belongs_to :user
  belongs_to :course_ware

  validates :user, :course_ware, :date, :presence => true

  scope :by_date, lambda { |date| 
    di = date.strftime("%Y%m%d").to_i
    {
      :conditions => {:date => di}
    }
  }

  scope :by_month, lambda { |month|
    { :conditions => {:month => month} }
  }

  scope :by_day, lambda { |day|
    { :conditions => {:day => day} }
  }

  scope :by_weekday, lambda { |weekday|
    { :conditions => {:weekday => weekday} }
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
      :weekday => date.wday,
      :year => date.year,
      :month => date.month,
      :day => date.day,

      :change => 0,
      :value => course_ware.read_count_value_of(user, date),
      :percent_change => '0%',
      :percent_value => course_ware.read_percent_value_of(user, date),
      :total_count => course_ware.total_count
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

    def read_percent_change_of(user, date)
      CourseWareReadingDelta.get_record_of(self, user, date).percent_change
    end

    # 获取指定日期的 read_count 值
    # 先查是否有小于等于指定日期的 delta 记录，如果有，直接返回 delta.value
    # 如果没有，就查找 reading 记录，看 reading 记录的 created_at 日期，是否早于指定的日期
    # 是 返回 reading.read_count
    # 否 返回 0
    def read_count_value_of(user, date)
      last_delta = _last_delta_of(user, date)
      return 0 if last_delta.blank?
      return last_delta.value
    end

    def read_percent_value_of(user, date)
      last_delta = _last_delta_of(user, date)
      return '0%' if last_delta.blank?
      return last_delta.percent_value
    end

    def last_week_read_count_changes_of(user)
      today = Date.today
      re = []

      6.downto 0 do |x|
        date = today - x
        re << {
          :date    => date,
          :weekday => date.wday,
          :change         => read_count_change_of(user, date),
          :value          => read_count_value_of(user, date),
          :percent_change => read_percent_change_of(user, date),
          :percent_value  => read_percent_value_of(user, date)
        }
      end

      return re
    end

    private
      def _last_delta_of(user, date)
        last_delta = CourseWareReadingDelta
          .of_course_ware(self)
          .of_user(user)
          .where('date <= ?', date.strftime("%Y%m%d").to_i)
          .order('date DESC')
          .first
      end
  end

  module CourseWareReadingMethods
    extend ActiveSupport::Concern

    included do
      # before_save :record_reading_delta
      # 此方法已经整合到 CourseWareReading 上的 set_default_and_save_delta 方法调用中
    end

    def record_reading_delta
      change = _get_read_count_change
      return true if change == 0

      percent_change = _get_read_percent_change

      delta = CourseWareReadingDelta.get_record_of(course_ware, user, Date.today)

      delta.change = delta.change + change
      delta.value = read_count

      delta.percent_change = "#{delta.percent_change.to_i + percent_change.to_i}%"
      delta.percent_value = read_percent

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

      def _get_read_percent_change
        return read_percent || '0%' if new_record?

        if read_percent_changed?
          before = read_percent_change[0] || '0%'
          after  = read_percent_change[1] || '0%'

          return "#{after.to_i - before.to_i}%"
        end

        return '0%'
      end
  end
end