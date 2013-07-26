class Question < ActiveRecord::Base
  acts_as_paranoid

  include CourseInteractive::QuestionMethods
  include QuestionFeedTimelime::QuestionMethods
  include QuestionFollow::QuestionMethods
  include QuestionVote::QuestionMethods
  
  attr_accessible :title, :content, :ask_to_user_id, :creator, :best_answer,
                  :course, :chapter, :course_ware, :reward,
                  :fine_answer_rewarded,
                  :best_answer_rewarded

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :ask_to, :class_name => 'User', :foreign_key => :ask_to_user_id
  
  belongs_to :course
  belongs_to :chapter
  belongs_to :course_ware

  belongs_to :best_answer, :class_name => 'Answer', :foreign_key => :best_answer_id
  belongs_to :step, polymorphic: true
  belongs_to :step_history


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
    if self.step.present?
      self.course_ware = self.step.course_ware
      self.chapter = self.course_ware.chapter
      self.course = self.chapter.course

    elsif self.course_ware.present?
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

  # 设置悬赏值
  def set_reward(new_reward)
    old_reward = self.reward||0
    reward_change = new_reward - old_reward

    if new_reward % 10 != 0
      raise '设置的悬赏值必须是 10 的倍数'
    end
    if new_reward < old_reward
      raise '设置的悬赏值不能小于以前的设置' 
    end
    if creator.credit_value < reward_change
      raise '你的贡献值不足以支付设置的悬赏值' 
    end

    self.update_attributes(:reward => new_reward)
    creator.add_credit(-reward_change, :deduct_reward_of_question, self)
    return true
  end

  # 设置最佳答案
  def set_best_answer(answer)
    if self.best_answer.present?
      _set_best_answer__change(answer)
    else
      _set_best_answer__first(answer)
    end
  end

  def _set_best_answer__first(answer)
    self.best_answer = answer
    return if !self.valid?

    answer_creator = self.best_answer.creator

    # 分配最佳答案贡献值
    answer_creator.add_credit(20, :add_credit_of_best_answer, self.best_answer)

    # 分配悬赏值
    reward_value = self.reward||0
    if reward_value > 0
      if !self.fine_answer_rewarded?
        fine_answers = self.answers.fine
        fine_answers.each do |answer|
          answer.creator.add_credit(reward_value/2, :add_reward_of_fine_answer, answer)
        end
      end
      answer_creator.add_credit(reward_value/2, :add_reward_of_best_answer, self.best_answer)
      self.fine_answer_rewarded = true
      self.best_answer_rewarded = true
    end

    self.save
  end

  def _set_best_answer__change(answer)
    old_best_answer = self.best_answer
    # 设置最佳答案
    self.update_attributes(:best_answer => answer)
    # 分配最佳答案贡献值
    old_best_answer.creator.add_credit(-20, :cancel_add_credit_of_best_answer, old_best_answer)
    self.best_answer.creator.add_credit(20, :add_credit_of_best_answer, self.best_answer)
    # 分配悬赏值
    reward_value = self.reward||0
    return if reward_value == 0

    old_best_answer.creator.add_credit(-reward_value/2, :cancel_add_reward_of_best_answer, old_best_answer)
    self.best_answer.creator.add_credit(reward_value/2, :add_reward_of_best_answer, self.best_answer)
  end

  def destroy_by_creator
    return if answers.count >= 2
    return if answers.count == 1 && answers.first.vote_sum > 0

    self.destroy
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

  searchable do
    text :title, :content

    text :answers_content do
      answers.pluck("answers.content")
    end
  end
end