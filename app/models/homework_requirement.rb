class HomeworkRequirement < ActiveRecord::Base
  attr_accessible :content

  belongs_to :homework

  validates :content, :presence => true

  has_many :homework_uploads, :foreign_key => :requirement_id

  def get_upload_by(user)
    self.homework_uploads.by_creator(user).first
  end

  def is_uploaded_by?(user)
    self.get_upload_by(user).present?
  end
end