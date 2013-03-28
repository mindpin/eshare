class TestPaper < ActiveRecord::Base
  attr_accessible :course_id, :user_id

  belongs_to :course
  belongs_to :user
  has_many :test_paper_items

  has_many :test_questions, :through => :test_paper_items
  validates :course_id, :presence => true
  validates :user_id,   :presence => true

  def self.make_test_paper_for(course,user)
    paper = self.create(:course_id => course.id,:user_id => user.id)
    paper.select_questions!
    paper
  end

  def select_questions!
    if self.test_questions.blank?
      test_questions = self.course.test_questions.to_a.shuffle
      selected = test_questions[0,10]
      self.test_questions = selected     
    end
  end

  def find_item_for(test_question)
    self.test_paper_items.where('test_question_id = ?', test_question.id).first
  end

  def self.find_paper_for(course, user)
    course.test_papers.find_by_user_id(user.id)
  end
end