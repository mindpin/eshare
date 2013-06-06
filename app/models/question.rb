class Question < ActiveRecord::Base
  include CourseInteractive::QuestionMethods
  include QuestionFeedTimelime::QuestionMethods
  include QuestionFollow::QuestionMethods
  include QuestionVote::QuestionMethods
  
  attr_accessible :title, :content, :ask_to_user_id, :creator, :best_answer,
                  :course, :chapter, :course_ware

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :ask_to, :class_name => 'User', :foreign_key => :ask_to_user_id
  
  belongs_to :course
  belongs_to :chapter
  belongs_to :course_ware

  belongs_to :best_answer, :class_name => 'Answer', :foreign_key => :best_answer_id
  has_many :answers
  has_many :question_votes, :dependent => :delete_all

  default_scope order('vote_sum desc')

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
    {:conditions => ['questions.course_id = ?', course.id]}
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

  before_save :update_course_related_attrs
  def update_course_related_attrs
    if self.course_ware.present?
      self.chapter = self.course_ware.chapter
      self.course = self.chapter.course
    elsif self.chapter.present?
      self.course = self.chapter.course
    end
  end

  def answered_by?(user)
    return false if user.blank?
    return self.answer_of(user).present?
  end

  def answer_of(user)
    return nil if user.blank?
    return self.answers.by_user(user).first
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