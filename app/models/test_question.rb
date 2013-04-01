class TestQuestion < ActiveRecord::Base
  KINDS = {
    "SINGLE_CHOICE" => :answer_choice,
    "MULTIPLE_CHOICE" => :answer_choice,
    "FILL" => :answer_fill,
    "TRUE_FALSE" => :answer_true_false
  }
  attr_accessible :title, 
                  :course_id, 
                  :creator_id, 
                  :kind, 
                  :choice_options, 
                  :answer_fill, 
                  :answer_true_false, 
                  :answer_choice,
                  :test_question_choice_options

  belongs_to :course
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :test_paper_items
  has_many :test_papers, :through => :test_paper_items

  validates :title,  :presence  => true
  validates :course, :presence  => true
  validates :creator,:presence  => true
  validates :kind,   :inclusion => KINDS.keys

  scope :with_kind, lambda {|kind| where('kind = ?', kind)}

  include AnswerChoice

  def test_question_choice_options=(opts)
    self.choice_options = opts.values.to_json
  end

  def test_question_choice_options
    ChoiceOptions.new(Hash[('A'..'E').zip(self.choice_options)])
  end

  def choice_options
    JSON.parse(self.read_attribute :choice_options)
  end
  
  class ChoiceOptions
    extend ActiveModel::Naming
    attr_accessor :result

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

