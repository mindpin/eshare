class SurveyItem < ActiveRecord::Base
  class Kind
    SINGLE_CHOICE = 'SINGLE_CHOICE'
    FILL = 'FILL'
    MULTIPLE_CHOICE = 'MULTIPLE_CHOICE'
    TEXT = 'TEXT'
  end

  attr_accessible :content, :choice_options, :kind

  belongs_to :survey

  validates :content, :kind, :survey, :presence => true
  validates :choice_options, :presence => {:if => lambda {|item|
    item.kind == Kind::SINGLE_CHOICE || item.kind == Kind::MULTIPLE_CHOICE
  }}

  def content_by_replace(replace_str)
    self.content.gsub('*', replace_str)
  end

  def choice_options=(array)
    write_attribute(:choice_options, array.to_json)
  end

  def choice_options
    ActiveSupport::JSON.decode(read_attribute(:choice_options))
  end
end
