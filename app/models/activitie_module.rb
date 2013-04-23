module ActivitieModule
  def self.included(base)
    base.has_many :activities, :foreign_key => :creator_id
  end
end