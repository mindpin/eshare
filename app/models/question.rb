class Question < ActiveRecord::Base
  include CourseInteractive::QuestionMethods
  include QuestionFeedTimelime::QuestionMethods
  include QuestionFollow::QuestionMethods
  
  attr_accessible :title, :content, :ask_to_user_id, :creator, :model, :best_answer

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :ask_to, :class_name => 'User', :foreign_key => :ask_to_user_id
  belongs_to :best_answer, :class_name => 'Answer', :foreign_key => :best_answer_id
  belongs_to :model, :polymorphic => true
  has_many :answers

  validates :creator, :title, :presence => true

  validate :validate_best_answer
  def validate_best_answer
    return true if best_answer.blank?
    if best_answer.question != self
      errors.add(:base, "最佳答案需要从问题的回答列表中选择")
    end
  end

  default_scope order('id desc')
  scope :anonymous, :conditions => ['is_anonymous = ?', true]
  scope :onymous, :conditions => ['is_anonymous = ?', false]
  scope :has_best_answer, :conditions => ['best_answer_id > 0']
  scope :today, :conditions => ['DATE(created_at) = ?',Time.now.to_date]
  scope :by_course, lambda {|course|

    chapter_ids = course.chapter_ids.to_a
    course_wares_ids = course.course_ware_ids.to_a
     
    wheres = ["(model_type = 'Course' and model_id = #{course.id})"]
    if !chapter_ids.blank?
      wheres << "(model_type = 'Chapter' and model_id in (#{chapter_ids*","}))"
    end
     
    if !course_wares_ids.blank?
      wheres << "(model_type = 'CourseWare' and model_id in (#{course_wares_ids*","}))"
    end
     
    {:conditions => wheres*" or "}
  }
  
  scope :on_date, lambda { |date|
    d = date.to_date
    {
      :conditions => [
        'created_at >= ? AND created_at < ?', d, d + 1.day
      ]
    }
  }

  # 记录用户活动
  record_feed :scene => :questions,
                        :callbacks => [:create, :update]

  before_save :update_actived_at
  def update_actived_at
    self.actived_at = Time.now if self.changed? || self.new_record?
  end

  def answered_by?(user)
    return false if user.blank?
    return self.answer_of(user).present?
  end

  def answer_of(user)
    return nil if user.blank?
    return self.answers.by_user(user).first
  end

  def course
    case self.model
    when Chapter
      self.model.course
    when Course
      self.model
    when CourseWare
      self.model.chapter.course
    else
      nil
    end
  rescue
    nil
  end

  module UserMethods
    def self.included(base)
      base.has_many :questions, :foreign_key => 'creator_id'
    end

    def notice_questions
      follows_questions = Question.joins(:follows).where(%`
        question_follows.user_id = #{self.id}
          and
        question_follows.last_view_time < questions.actived_at
      `)

      ask_to_questions = Question.joins(%`
        left join answers on answers.question_id = questions.id
      `).where(%`
        questions.ask_to_user_id = #{self.id}
          and
        answers.id is null
      `)

      questions = follows_questions + ask_to_questions
      questions.sort_by(&:actived_at).reverse
    end
  end
end