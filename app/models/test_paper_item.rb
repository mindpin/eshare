class TestPaperItem < ActiveRecord::Base
  include AnswerChoice
  attr_accessible :test_paper_id, 
                  :test_question_id,
                  :answer,
                  :answer_fill, 
                  :answer_true_false, 
                  :answer_choice,
                  :fill_fields

  belongs_to :test_paper
  belongs_to :test_question

  validates :test_paper_id,    :presence => true
  validates :test_question_id, :presence => true

  delegate :kind,   :to => :test_question
  delegate :course, :to => :test_question
  delegate :title,  :to => :test_question

  scope :with_kind, lambda {|kind| joins(:test_question).where('test_questions.kind = ?', kind)}

  def score?
    self.send(answer) == self.test_question.send(answer)
  end

  def point
    self.course.test_option.test_option_rule.send(self.kind.downcase).point.to_i
  end

  def fill_fields
    return if self.kind != 'FILL'
    x = FillFields.new self.title, self.answer_fill ? self.answer_fill.split(',') : []
  end

  def fill_fields=(input)
    return if self.kind != 'FILL'
    self.answer_fill = input.sort_by {|pair| pair[0]}.map {|pair| pair[1]}.join(',')
  end

  def each_fill_field(&block)
    Enumerator.new do |yielder|
      self.title.split(/(\*)/).reject(&:blank?).each do |i|
        i == '*' ? yielder << i : block.call(i)
      end
    end
  end
end