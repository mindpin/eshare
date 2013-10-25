# -*- coding: utf-8 -*-
class EnvironmentConfigStateRelation < ActiveRecord::Base
  attr_accessible :parent_state, :child_state

  belongs_to :parent_state, :class_name => 'EnvironmentConfigState',
             :foreign_key => :parent_state_id

  belongs_to :child_state, :class_name => 'EnvironmentConfigState',
             :foreign_key => :child_state_id


  validates :parent_state, :child_state, :presence => true

end