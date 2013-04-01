class TestPaper < ActiveRecord::Base
  attr_accessible :course_id, :user_id, :score

  belongs_to :course
  belongs_to :user
  has_many :test_paper_items

  has_many :test_questions, :through => :test_paper_items
  validates :course_id, :presence => true
  validates :user_id,   :presence => true

  delegate :test_option, :to => :course

  def self.make_test_paper_for(course, user)
    paper = self.create(:course_id => course.id,:user_id => user.id)
    paper.test_questions = paper.select_questions
    paper
  end

  def select_questions
    return [] if test_option.blank?
    TestQuestion::KINDS.keys.map do |kind|
      self.course.test_questions.with_kind(kind).to_a.shuffle[0, option_count_for(kind)]
    end.flatten.uniq
  end

  def option_count_for(kind)
    self.test_option.test_option_rule.send(kind.downcase).count.to_i
  end

  def find_item_for(test_question)
    self.test_paper_items.where('test_question_id = ?', test_question.id).first
  end

  def self.find_paper_for(course, user)
    course.test_papers.find_by_user_id(user.id)
  end

  def score
    self.test_paper_items.inject(0) do |acc, item|
      item.score? ? acc + item.point : acc
    end
  end
end