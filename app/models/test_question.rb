class TestQuestion < ActiveRecord::Base
  include AnswerChoice

  attr_accessible :title, 
                  :course_id, 
                  :creator_id, 
                  :kind, 
                  :choice_options,
                  :answer,
                  :answer_fill, 
                  :answer_true_false, 
                  :answer_choice 
                  :test_question_choice_options

  belongs_to :course
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :test_paper_items, :dependent => :destroy
  has_many :test_papers, :through => :test_paper_items

  validates :title,  :presence  => true
  validates :course, :presence  => true
  validates :creator,:presence  => true
  validates :kind,   :inclusion => KINDS.keys, :presence  => true

  scope :with_kind, lambda {|kind| where('kind = ?', kind)}

  validate do
    if test_question_choice_options.invalid? && ['SINGLE_CHOICE', 'MULTIPLE_CHOICE'].include?(self.kind)
      errors.add(:base, '没有录入足够的选项')
    end
  end

  def test_question_choice_options=(opts)
    return if opts.values.join('').blank?
    self.choice_options = opts.values.to_json
  end

  def test_question_choice_options
    ChoiceOptions.new(Hash[('A'..'E').zip(self.choice_options)])
  end

  def choice_options
    JSON.parse(read_attribute(:choice_options) || '[]')
  end

  class ChoiceOptions
    extend ActiveModel::Naming
    include ActiveModel::Validations
    attr_accessor :result

    validates *(:a..:e).to_a, :presence => true

    def initialize(result = {})
      @result = result
      ('A'..'E').each do |option|
        define_singleton_method option.downcase do
          @result[option.upcase]
        end
        define_singleton_method "#{option.downcase}=" do |val|
          @result[option.upcase] = val
        end
      end
    end
  end
end

