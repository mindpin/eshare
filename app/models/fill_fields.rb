class FillFields
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_accessor :answers, :question, :count

  def initialize(question, answers)
    @question = question
    @answers = answers
    @count = question.count('*')
    1.upto(@count).each do |num|
      define_singleton_method "field#{num}" do
        @answers[num - 1]
      end
      define_singleton_method "field#{num}=" do |val|
        @answers[num - 1] = val
      end
    end
  end
end