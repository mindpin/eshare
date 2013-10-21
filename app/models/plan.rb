class Plan < ActiveRecord::Base
  attr_accessible :knowledge_net_id, :course, :day_num

  belongs_to :course
  belongs_to :user

  scope :with_knowledge_net, ->(net) {where(:knowledge_net_id => net.id)}

  module CourseMethods
    def self.included(base)
      base.send :has_many, :plans
    end
  end

  module UserMethods
    def self.included(base)
      base.send :has_many, :plans
    end
  end
end
