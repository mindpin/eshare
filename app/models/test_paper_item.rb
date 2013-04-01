class TestPaperItem < ActiveRecord::Base
  include AnswerChoice
  attr_accessible :test_paper_id, 
                  :test_question_id, 
                  :answer_fill, 
                  :answer_true_false, 
                  :answer_choice

  belongs_to :test_paper
  belongs_to :test_question

  validates :test_paper_id,    :presence => true
  validates :test_question_id, :presence => true

  delegate :kind,   :to => :test_question
  delegate :course, :to => :test_question

  scope :with_kind, lambda {|kind| joins(:test_question).where('test_questions.kind = ?', kind)}

  def score?
    self.send(answer) == self.test_question.send(answer)
  end

  def point
    self.course.test_option.test_option_rule.send(self.kind.downcase).point.to_i
  end

end