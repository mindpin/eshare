class TestPaperItem < ActiveRecord::Base
  attr_accessible :test_paper_id, 
                  :test_question_id, 
                  :answer_fill, 
                  :answer_true_false, 
                  :answer_choice

  belongs_to :test_paper
  belongs_to :test_question

  validates :test_paper_id,      :presence => true
  validates :test_question_id,   :presence => true

  include AnswerChoice
end