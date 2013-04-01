class SurveyResultItem < ActiveRecord::Base
  attr_accessible :answer

  belongs_to :survey_result
  belongs_to :survey_item

  validates :survey_result, :survey_item, :presence => true

  validates :answer_choice_mask, :presence => {:if=> lambda {|item|
    !item.survey_item.blank? && (
      item.survey_item.kind == SurveyItem::Kind::SINGLE_CHOICE ||
        item.survey_item.kind == SurveyItem::Kind::MULTIPLE_CHOICE
      )
  }}

  validates :answer_fill, :presence => {:if=> lambda {|item|
    !item.survey_item.blank? && item.survey_item.kind == SurveyItem::Kind::FILL
  }}

  validates :answer_text, :presence => {:if=> lambda {|item|
    !item.survey_item.blank? && item.survey_item.kind == SurveyItem::Kind::TEXT
  }}

  before_validation :set_answer_value
  def set_answer_value
    return if self.survey_item.blank?

    case self.survey_item.kind
    when SurveyItem::Kind::SINGLE_CHOICE, SurveyItem::Kind::MULTIPLE_CHOICE
      self.answer_choice = @answer
    when SurveyItem::Kind::TEXT
      self.answer_text = @answer
    when SurveyItem::Kind::FILL
      self.answer_fill = @answer
    end
  end

  def answer=(answer)
    @answer = answer
  end

  def answer_choice=(choices)
    value = choices.upcase.split('').map do |choice|
     2 ** ('A'..'Z').to_a.index(choice.to_s.upcase)
    end.sum
    write_attribute(:answer_choice_mask, value)
  end

  def answer_choice
    answer_choice_mask &&
    answer_choice_mask.to_s(2).chars.reverse.each_with_index.inject([]) do |acc, (num,index)|
      num == "1" ? acc + [('A'..'Z').to_a[index]] : acc
    end.compact.sort.join('')
  end
end
