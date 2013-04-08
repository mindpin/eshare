class SurveyResult < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  belongs_to :survey

  validates :creator, :survey, :presence => true
  validates :creator_id, :uniqueness => {:scope => :survey_id}

  has_many :survey_result_items
  accepts_nested_attributes_for :survey_result_items

  scope :by_user, lambda {|user| {:conditions => ['creator_id = ?',user.id]} }

  validate :check_survey_result_items
  def check_survey_result_items
    ids = self.survey_result_items.map(&:survey_item_id).uniq.sort
    must_ids = self.survey.survey_items.map(&:id).sort
    if ids != must_ids
      errors.add(:survey_result_items, "参数错误")
    end

  end
end
