# -*- coding: utf-8 -*-
class EnvironmentConfigState < ActiveRecord::Base
  attr_accessible :title, :content, :course_ware

  belongs_to :course_ware
  has_many :parent_relations, :class_name => 'EnvironmentConfigStateRelation', 
           :foreign_key => :child_state_id

  has_many :child_relations, :class_name => 'EnvironmentConfigStateRelation', 
           :foreign_key => :parent_state_id

  has_many :parent_states, :through => :parent_relations
  has_many :child_states, :through => :child_relations

  validates :course_ware, :title, :content,
            :presence => true



  module CourseWareMethods
    def self.included(base)
      base.has_many :environment_config_states
    end

    def root_environment_config_states
      environment_config_states.select { |state| state if state.parent_states.blank? }
    end
  end

end