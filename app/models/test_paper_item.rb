class TestPaperItem < ActiveRecord::Base
  include AnswerChoice
  attr_accessible :test_paper_id, 
                  :test_question_id, 
                  :answer_fill, 
                  :answer_true_false, 
                  :answer_choice

  belongs_to :test_paper
  belongs_to :test_question

  validates :test_paper_id,      :presence => true
  validates :test_question_id,   :presence => true

  delegate :kind,             :to => :test_question
  delegate :course,           :to => :test_question
  delegate :test_option,      :to => :course
  delegate :test_option_rule, :to => :test_option

  def score?
    self.send(answer_field) == self.test_question.send(answer_field)
  end

  def answer_field
    TestQuestion::KINDS[self.kind]
  end

  def point
    self.test_option_rule.send(self.kind.downcase).point.to_i
  end
end