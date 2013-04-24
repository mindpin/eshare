class Question < ActiveRecord::Base
  include CourseInteractive::QuestionMethods
  
  attr_accessible :title, :content, :ask_to_user_id, :creator, :model, :best_answer

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :ask_to, :class_name => 'User', :foreign_key => :ask_to_user_id
  belongs_to :best_answer, :class_name => 'Answer', :foreign_key => :best_answer_id
  belongs_to :model, :polymorphic => true
  has_many :answers
  has_many :follows, :class_name => 'QuestionFollow', :foreign_key => :question_id

  validates :creator, :title, :presence => true

  validate :validate_best_answer
  def validate_best_answer
    return true if best_answer.blank?

    if !answers.include?(best_answer)
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

  after_create :follow_by_creator
  def follow_by_creator
    self.follow_by_user(self.creator)
  end

  # 记录用户活动
  record_feed :scene => :questions,
                        :callbacks => [ :create, :update]

  def answered_by?(user)
    return false if user.blank?
    return self.answer_of(user).present?
  end

  def answer_of(user)
    return nil if user.blank?
    return self.answers.by_user(user).first
  end

  def follow_by_user(user)
    self.follows.create(:user => user, :question => self, :last_view_time => Time.now)
  end

  def unfollow_by_user(user)
    self.get_follower_by(user).destroy
  end


  def followed_by?(user)
    self.get_follower_by(user).present?
  end

  def get_follower_by(user)
    self.follows.by_user(user).first
  end

  def visit_by!(user)
    return if !self.followed_by?(user)

    question_follow = self.get_follower_by(user)

    question_follow.last_view_time = Time.now
    question_follow.save
    question_follow.reload
  end

  module UserMethods
    def self.included(base)
      base.has_many :questions, :foreign_key => 'creator_id'
    end

    def notice_questions
      follows_questions = Question.joins(:follows).where(%`
        question_follows.user_id = #{self.id}
          and
        question_follows.last_view_time < questions.updated_at
      `)

      ask_to_questions = Question.joins(%`
        left join answers on answers.question_id = questions.id
      `).where(%`
        questions.ask_to_user_id = #{self.id}
          and
        answers.id is null
      `)

      questions = follows_questions + ask_to_questions
      questions.sort_by(&:updated_at).reverse
    end
  end
end