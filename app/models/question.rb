class Question < ActiveRecord::Base
  include CourseInteractive::QuestionMethods
  
  attr_accessible :title, :content, :chapter_id, :ask_to_user_id, :creator

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :ask_to, :class_name => 'User', :foreign_key => :ask_to_user_id
  belongs_to :chapter
  has_many :answers
  has_many :question_follows
  has_many :follows, :class_name => 'QuestionFollow', :foreign_key => :question_id

  validates :creator, :title, :content, :presence => true

  default_scope order('id desc')

  scope :today, :conditions => ['DATE(created_at) = ?',Time.now.to_date]
  scope :by_course, lambda {|course|
    ids = course.chapter_ids.to_a
    if ids.blank?
      {:conditions => 'chapter_id = -1'}
    else
      {:conditions => {:chapter_id => ids}}
    end
  }

  scope :anonymous, :conditions => ['is_anonymous' = true]
  scope :onymous, :conditions => ['is_anonymous' = false]

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

  after_save :follow_by_creator

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
      follows_questions = Question.joins(:question_follows).where(%`
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