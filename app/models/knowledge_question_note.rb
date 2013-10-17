# -*- coding: utf-8 -*-
class KnowledgeQuestionNote < ActiveRecord::Base
  attr_accessible :knowledge_question, :creator, :content, :image, :code, :code_type

  belongs_to :knowledge_question
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  validates :knowledge_question, :creator, :code_type,
            :presence => true



  module UserMethods
    def self.included(base)
      base.has_many :knowledge_question_notes, :foreign_key => 'creator_id'
    end
  end

end