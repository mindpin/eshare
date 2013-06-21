module CourseUpdateStatusMethods
  def self.included(base)
    base.scope :with_new_status, :conditions => [
      'courses.created_at > ? and courses.course_wares_count > 0', 
      Time.now - 7.day 
    ]

    base.scope :with_updated_status, :conditions => [
      'courses.created_at < ? and courses.updated_at > ? and courses.course_wares_count > 0',
      Time.now - 7.day, Time.now - 7.day
    ]

    base.scope :with_nochange_status, :conditions => [
      'courses.updated_at < ? or courses.course_wares_count = 0',
      Time.now - 7.day
    ]
  end


  class UpdateStatus
    NEW      = 'NEW'
    UPDATED  = 'UPDATED'
    NOCHANGE = 'NOCHANGE'
  end

  def get_update_status
    now = Time.now
    if now - self.created_at < 7.day && self.course_wares_count > 0
      return UpdateStatus::NEW
    end

    if now - self.created_at > 7.day && now - self.updated_at < 7.day && self.course_wares_count > 0
      return UpdateStatus::UPDATED
    end

    return UpdateStatus::NOCHANGE
  end
end