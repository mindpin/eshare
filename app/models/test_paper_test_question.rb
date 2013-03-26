class TestPaperTestQuestion < ActiveRecord::Base
  attr_accessible :test_paper_id, :test_question_id

  belongs_to :test_paper
  belongs_to :test_question

  validates :test_paper_id,      :presence => true
  validates :test_question_id,   :presence => true

end