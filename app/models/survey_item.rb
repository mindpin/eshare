class SurveyItem < ActiveRecord::Base
  class Kind
    SINGLE_CHOICE = 'SINGLE_CHOICE'
    FILL = 'FILL'
    MULTIPLE_CHOICE = 'MULTIPLE_CHOICE'
    TEXT = 'TEXT'
  end

  KINDS = [Kind::SINGLE_CHOICE, Kind::FILL, Kind::MULTIPLE_CHOICE, Kind::TEXT ]

  attr_accessible :content, :choice_options, :kind, :choice_options_str

  belongs_to :survey

  validates :content, :kind, :survey, :presence => true
  validates :kind, :inclusion => {:in => KINDS}
  validates :choice_options, :presence => {:if => lambda {|item|
    item.is_choice?
  }}

  def is_single_choice?
    kind == Kind::SINGLE_CHOICE
  end

  def is_multiple_choice?
    kind == Kind::MULTIPLE_CHOICE
  end

  def is_choice?
    is_multiple_choice? || is_single_choice?
  end

  def is_fill?
    kind == Kind::FILL
  end

  def is_text?
    kind == Kind::TEXT
  end

  def content_by_replace(replace_str)
    self.content.gsub('*', replace_str)
  end

  def choice_options_str=(str)
    @choice_options_str = str
    self.choice_options = str.split(/\r?\n/)
  end

  def choice_options_str
    @choice_options_str
  end

  def choice_options=(array)
    write_attribute(:choice_options, array.to_json)
  end

  def choice_options
    ActiveSupport::JSON.decode(read_attribute(:choice_options))
  end
end
