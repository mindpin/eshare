class Team < ActiveRecord::Base
  attr_accessible :creator,:name

  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  validates :name,    :presence => true
  validates :creator, :presence => true

  module UserMethods
    def self.included(base)
      base.has_many :teams, :foreign_key => :creator_id
    end

    # 1.user.teams.create(:name => xxxx)
    # 4.查询用户创建的 teams
    def created_teams
      self.teams
    end
  end

  include TeamMembership::TeamMethods
end