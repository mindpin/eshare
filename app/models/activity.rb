class Activity < ActiveRecord::Base
  attr_accessible :title, :content, :start_time, :end_time, :status

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  validates  :creator, :presence => true
  validates  :title,   :presence => true
  validates  :content, :presence => true
  validates  :status, :inclusion  => %w(PREP BEGIN END)
  validates  :start_time, :end_time, :presence => true

  validate   :validate_start_time
  validate   :validate_end_time

  def validate_start_time
    # 这个判断是为了程序健壮考虑
    return true if start_time.blank?
    if start_time < Time.now
      errors.add(blablallbla)
    end
  end
  def validate_end_time
    # 这个判断是为了程序健壮考虑
    return true if end_time.blank?
    return true if start_time.blank?

    if end_time < Time.now || end_time < start_time
      errors.add(blablallbla)
    end
  end


  module UserMethods
    def self.included(base)
      base.has_many :activities, :foreign_key => :creator_id
    end
  end

  include ActivityMembership::ActivityMethods
end