class Survey < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :creator, :class_name => 'User'

  validates :title, :creator, :presence => true

  has_many :survey_items
  has_many :survey_results

  def is_answered?(current_user)
    self.survey_results.where(:creator_id => current_user.id).present?
  end

  def record_result(user, params)
    SurveyResult.transaction do
      result = self.survey_results.build
      result.creator = user
      result.save!

      params.each do |survey_item_id, answer|
        survey_item = self.survey_items.find(survey_item_id)
        sri = result.survey_result_items.build(:answer => answer[:answer])
        sri.survey_item = survey_item
        sri.save!
      end
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :surveys, :foreign_key => :creator_id
    end
  end
end
