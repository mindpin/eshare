class HomeworkRequirement < ActiveRecord::Base
  attr_accessible :content

  belongs_to :homework

  validates :content, :presence => true

  has_many :homework_uploads, :foreign_key => :requirement_id

  def upload_by(user)
    self.homework_uploads.where(:creator_id => user.id).first
  end

  def is_uploaded_by?(user)
    self.upload_by(user).present?
  end
end