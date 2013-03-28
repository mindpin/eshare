class TestOption < ActiveRecord::Base
  attr_accessible :course_id, 
                  :test_option_rule

  belongs_to :course

  validates :course, :presence => true

  def test_option_rule=(rule)
    write_attribute :rule, rule.to_json
  end

  def test_option_rule
    Rule.new(JSON.parse(read_attribute :rule))
  end

  class Rule
    extend ActiveModel::Naming
    attr_accessor :result
    def initialize(result = {})
      @result = result.symbolize_keys
      [:single_choice,:multiple_choice,:fill,:true_false].each do |option|
        define_singleton_method option do
          Scoring.new(@result[option] || {})
        end
        define_singleton_method "#{option}=" do |scoring|
          @result[option] = scoring.result
          scoring
        end
      end
    end
  end

  class Scoring
    extend ActiveModel::Naming
    attr_accessor :result
    def initialize(result = {})
      @result = result.symbolize_keys
      [:count,:point].each do |option|
        define_singleton_method option do
          @result[option]
        end
        define_singleton_method "#{option}=" do |val|
          @result[option] = val
        end
      end
    end
  end
end
