class SurveyResultItem < ActiveRecord::Base
  attr_accessible :answer

  belongs_to :survey_result
  belongs_to :survey_item

  validates :survey_result, :survey_item, :presence => true

  validates :answer_choice_mask, :presence => {:if=> lambda {|item|
    !item.survey_item.blank? && (
      item.survey_item.is_choice?
      )
  }}

  validates :answer_fill, :presence => {:if=> lambda {|item|
    !item.survey_item.blank? && item.survey_item.is_fill?
  }}

  validates :answer_text, :presence => {:if=> lambda {|item|
    !item.survey_item.blank? && item.survey_item.is_text?
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

  scope :by_survey_item, lambda {|survey_item| {:conditions => ['survey_item_id = ?', survey_item.id] }}

  def answer=(answer)
    @answer = [answer].flatten*","
  end

  def answer
    case self.survey_item.kind
    when SurveyItem::Kind::SINGLE_CHOICE, SurveyItem::Kind::MULTIPLE_CHOICE
      self.answer_choice
    when SurveyItem::Kind::TEXT
      self.answer_text
    when SurveyItem::Kind::FILL
      self.answer_fill
    end
  end

  def answer_choice=(choices)
    choice_arr = choices.upcase.split('')
    choice_arr.delete(',')
    value = choice_arr.map do |choice|
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
